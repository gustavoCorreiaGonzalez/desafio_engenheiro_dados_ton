variable "zone" {
  description = "Zona de servidores que ficará provisionada a infraestrutura"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "IPv4 para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "prefix" {
  description = "Prefixo do projeto"
  type        = string
  default     = "redshift"
}

variable "redshift_port" {
  description = "Porta de conexão com o redshift"
  type        = number
  default     = 5439
}

variable "redshift_subnet_cidr_first" {
  description = "IPv4 para a primeira subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "redshift_subnet_cidr_second" {
  description = "IPv4 para a segunda subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "redshift_subnet_cidr_third" {
  description = "IPv4 para a segunda subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "rs_cluster_identifier" {
  description = "Nome do cluster Redshift"
  type        = string
  default     = "redshift-cluster"
}

variable "rs_database_name" {
  description = "Nome da base de dados"
  type        = string
  default     = "database_cluster"
}

variable "rs_master_username" {
  description = "Nome do usuário do banco de dados"
  type        = string
  default     = "redshift_user"
}

variable "rs_master_password" {
  description = "Senha do banco de dados"
  type        = string
  default     = "SenhaTeste1!"
}
