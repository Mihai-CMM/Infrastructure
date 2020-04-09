# Terraform & FE => ♥ UiPath Orchestrator.
Steps to provision VPC and Internet access on FE:
1. Install terraform  v0.12.12 (https://learn.hashicorp.com/terraform/getting-started/install.html).
2. Complete the variables.tf file (see inputs below). 
3. Fill your openstack credentials in passowrds file  --see password.mock
4. Source that file on a linux VM   
5. Manually create security group and virtual IP for internet access 
6. Run : ` terraform init `
7. Run : ` terraform plan `
8. Check the plan of the resources to be deployed and type ` yes ` if you agree with the plan.` terrafrom apply `


#Note: a. If you allready use a tenant, a vpc and have access to internet you might not need to use this part which is common to both orchestrator and robots
       b. From WebUi you need to also create a keypair "default=uipath" to connect to Redis/HAA machines
## Terraform version
Terraform v0.12.12

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| environment | Environment name, used as prefix to tag the name of the resources. | string | `"dev"` | yes |
| vpc_name | Name used for your VPC where you deploy uiptah resources | string | `"uipath"` | yes |
| vpc_cidr | IP used for your VPC where you deploy uiptah resources | string | `"172.19.0.0/16"` | yes |
| subnet_name | Subnet name used for your VPC where you deploy uiptah resources | string | `"uipath_subnet"` | yes | 
| subnet_cidr | Subnet IP used for your VPC where you deploy uiptah resources | string | `"172.19.1.0/24"` | yes | 
| nat_floating_ip_id | ID of the IP used for internet access | string | `COLLECT FROM WEBUI` | yes |
| default_sec_group | ID of SG used for this VPC | string | `COLLECT FROM WEBUI` | yes |

