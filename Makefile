all: tf_apply

generate_project_name: project_name
	echo "dataops$$(cat --bytes 256 /dev/urandom | md5sum | awk '{print $$1}' )" > project_name


folder: generate_project_name
	yc resource-manager folder create --name $$(cat project_name)


tfvars: folder
	echo project_name="$$(cat project_name)" > terraform.tfvars
	echo 'yc_zone = "ru-central1-b"' >> terraform.tfvars
	echo 'dataproc_version="2.0"' >> terraform.tfvars
	echo 'bucket_name="dataops-bucket'$$(cat --bytes 256 /dev/urandom | md5sum | awk '{print $$1}' )'"'
	yc resource-manager folder get $$(cat project_name) | head -n2 | awk -F':| ' '{printf "%s=\"%s\"\n", $$1, $$NF}' >> terraform.tfvars
	yc iam create-token --folder-name $$(cat project_name) | awk '{printf "yc_token=\"%s\"\n", $$0}' >> terraform.tfvars


tf_plan: tfvars
	terraform plan


tf_apply: tfvars
	terraform apply --auto-approve


destroy:
	terraform destroy--auto-approve


clean: tf_destroy
	yc resource-manager folder delete $$(cat project_name) --async
