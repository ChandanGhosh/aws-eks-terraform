# aws-eks-terraform
A EKS deployment using terraform IaC using supported Ubuntu AMI instead of default Amazon Optimized Linux AMI Id. It automatically detect and fetch the latest Ubuntu AMI for the region and the kubernetes version getting deployed. It takes care of provisioning worker node using node template in autoscale group, auto join the node to the cluster, creates kubernetes namespace, docker registry secret etc. It also provision gateway load balancer, endpoint services, automatically fetch node instance id and create load balancer target group for demonstration.

## EKS Terraform deployment (AWS)

### Pre-Reqs

* aws-cli - https://aws.amazon.com/cli/ 
* terraform cli - https://learn.hashicorp.com/tutorials/terraform/install-cli 

* AWS IAM Account

* Use the `access-key` and `access-secret` of the above IAM user for the terraform deployment to avoid any permission issues

**IMPORTANT!!**

***Please donot jump between regions when the EKS is created already using terraform for a region. We are not maintaining multiple workspaces for tfstates at present. So, once done, cleanup resources and then switch to a different region for deployment if needed.***

Install the terraform dependencies.

```
cd deploy/terraform/aws
```
```
terraform init --upgrade
```

Create terraform plan for deployment
```
terraform plan -var 'aws_access_key=<access-key>' -var 'aws_secret_key=<access-secret>' \
-var 'region=<aws-region>' -var 'app_registry_server=<docker-registry-server>' \
-var 'app_registry_user=<docker-registry-user>' -var 'app_registry_password=<docker-registry-password>'
```

Apply terraform plan to deploy all the EKS resources. 

**Please note, The all the resources deployment including cluster provisioning takes ~ 20 mins.**

**If no *region* is passed to the command, the cluster will be deployed in eu-west-1 (Ireland)**
```
terraform apply -var 'aws_access_key=<access-key>' -var 'aws_secret_key=<access-secret>' \
-var 'region=<aws-region>' -var 'app_registry_server=<docker-registry-server>' \
-var 'app_registry_user=<docker-registry-user>' -var 'app_registry_password=<docker-registry-password>' --auto-approve
```
To clean-up resources
```
terraform destroy -var 'aws_access_key=<access-key>' -var 'aws_secret_key=<access-secret>' \
-var 'region=<aws-region>' -var 'app_registry_password=<docker-registry-password>' --auto-approve
```