# terraform-aws-basic-instance
Basic AWS Instance deployment with terraform

## If using doormat (HashiCorp Internal)

```sh
doormat --refresh
export TFH_name=terraform-aws-basic-instance
export TFH_org=HashiCorp-Sam
export TFH_hostname=app.terraform.io
account=$(doormat aws --list | grep arn | awk -F':' '{print $5}')
doormat aws --account ${account} \
  --tf-push --tf-workspace ${TFH_name} \
  --tf-organization ${TFH_org} \
  --tf-hostname ${TFH_hostname}
  ```