<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.redshift_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.s3_full_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_redshift_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_redshiftserverless_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_namespace) | resource |
| [aws_redshiftserverless_workgroup.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_workgroup) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.first](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.second](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.third](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefixo do projeto | `string` | `"redshift"` | no |
| <a name="input_redshift_port"></a> [redshift\_port](#input\_redshift\_port) | Porta de conexão com o redshift | `number` | `5439` | no |
| <a name="input_redshift_subnet_cidr_first"></a> [redshift\_subnet\_cidr\_first](#input\_redshift\_subnet\_cidr\_first) | IPv4 para a primeira subnet | `string` | `"10.0.1.0/24"` | no |
| <a name="input_redshift_subnet_cidr_second"></a> [redshift\_subnet\_cidr\_second](#input\_redshift\_subnet\_cidr\_second) | IPv4 para a segunda subnet | `string` | `"10.0.2.0/24"` | no |
| <a name="input_redshift_subnet_cidr_third"></a> [redshift\_subnet\_cidr\_third](#input\_redshift\_subnet\_cidr\_third) | IPv4 para a segunda subnet | `string` | `"10.0.3.0/24"` | no |
| <a name="input_rs_cluster_identifier"></a> [rs\_cluster\_identifier](#input\_rs\_cluster\_identifier) | Nome do cluster Redshift | `string` | `"redshift-cluster"` | no |
| <a name="input_rs_database_name"></a> [rs\_database\_name](#input\_rs\_database\_name) | Nome da base de dados | `string` | `"database_cluster"` | no |
| <a name="input_rs_master_password"></a> [rs\_master\_password](#input\_rs\_master\_password) | Senha do banco de dados | `string` | `"SenhaTeste1!"` | no |
| <a name="input_rs_master_username"></a> [rs\_master\_username](#input\_rs\_master\_username) | Nome do usuário do banco de dados | `string` | `"redshift_user"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | IPv4 para a VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zona de servidores que ficará provisionada a infraestrutura | `string` | `"us-east-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->