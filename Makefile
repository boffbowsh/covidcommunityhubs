.requirements.txt: Pipfile Pipfile.lock
	pipenv lock -r > .requirements.txt

.requirements: .requirements.txt
	rm -rf .requirements
	mkdir .requirements
	pip install -r .requirements.txt --no-deps -t .requirements

package.zip: .requirements api/*.py
	rm -f package.zip
	(cd .requirements ; zip ../package.zip -r *)
	(cd api ; zip ../package.zip -r *.py)

.PHONY: deploy_api deploy_site
deploy_api: package.zip
	aws s3 cp package.zip s3://theyhelpyou/package-$(word 1,$(shell md5sum package.zip)).zip
	aws lambda update-function-code --region eu-west-2 --function-name theyhelpyou_fetch_by_postcode --s3-bucket theyhelpyou --s3-key package-$(word 1,$(shell md5sum package.zip)).zip --publish
	aws lambda update-function-code --region eu-west-2 --function-name theyhelpyou_import_sheet --s3-bucket theyhelpyou --s3-key package-$(word 1,$(shell md5sum package.zip)).zip --publish
	aws lambda update-function-code --region eu-west-2 --function-name theyhelpyou_report_a_problem --s3-bucket theyhelpyou --s3-key package-$(word 1,$(shell md5sum package.zip)).zip --publish
	aws lambda update-function-code --region eu-west-2 --function-name theyhelpyou_export_for_llm --s3-bucket theyhelpyou --s3-key package-$(word 1,$(shell md5sum package.zip)).zip --publish
	aws lambda update-function-code --region eu-west-2 --function-name theyhelpyou_update_attr --s3-bucket theyhelpyou --s3-key package-$(word 1,$(shell md5sum package.zip)).zip --publish
	aws lambda update-function-code --region eu-west-2 --function-name theyhelpyou_import_from_llm --s3-bucket theyhelpyou --s3-key package-$(word 1,$(shell md5sum package.zip)).zip --publish

deploy_site: site/index.html
	aws s3 sync site s3://theyhelpyou/ --acl public-read --cache-control max-age=300

test:
	pipenv run pytest api
