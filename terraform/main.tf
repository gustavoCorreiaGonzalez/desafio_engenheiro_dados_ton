provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name        = "${var.prefix}-vpc"
    Environment = "Dev"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.prefix}-igw"
    Environment = "Dev"
  }

  depends_on = [aws_vpc.this]
}

resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = var.redshift_port
    to_port     = var.redshift_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix}-sg"
    Environment = "Dev"
  }

  depends_on = [aws_vpc.this]
}

resource "aws_subnet" "first" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.redshift_subnet_cidr_first
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name        = "${var.prefix}-subnet-1"
    Environment = "Dev"
  }

  depends_on = [aws_vpc.this]
}

resource "aws_subnet" "second" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.redshift_subnet_cidr_second
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name        = "${var.prefix}-subnet-2"
    Environment = "Dev"
  }

  depends_on = [aws_vpc.this]
}

resource "aws_redshift_subnet_group" "this" {
  name = "${var.prefix}-subnet-group"
  subnet_ids = [
    "${aws_subnet.first.id}",
    "${aws_subnet.second.id}"
  ]

  tags = {
    Name        = "${var.prefix}-subnet-group"
    Environment = "Dev"
  }

  depends_on = [aws_subnet.first, aws_subnet.second]
}

resource "aws_iam_role" "redshift_role" {
  name               = "${var.prefix}_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_full_access_policy" {
  name   = "${var.prefix}_s3_policy"
  role   = aws_iam_role.redshift_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "this" {
  bucket = "desafio-ton-${var.prefix}-bucket"

  tags = {
    Name        = "${var.prefix}-s3-bucket"
    Environment = "Dev"
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}

resource "random_string" "unique_suffix" {
  length  = 6
  special = false
}

resource "aws_redshift_cluster" "this" {
  cluster_identifier        = var.rs_cluster_identifier
  database_name             = var.rs_database_name
  master_username           = var.rs_master_username
  master_password           = random_password.this.result
  node_type                 = var.rs_nodetype
  cluster_type              = var.rs_cluster_type
  cluster_subnet_group_name = aws_redshift_subnet_group.this.id
  skip_final_snapshot       = true
  iam_roles                 = ["${aws_iam_role.redshift_role.arn}"]

  tags = {
    Name        = "${var.prefix}-redshift-cluster"
    Environment = "Dev"
  }

  depends_on = [
    aws_vpc.this,
    aws_security_group.this,
    aws_redshift_subnet_group.this,
    aws_iam_role.redshift_role,
  ]
}

resource "aws_secretsmanager_secret" "redshift_connection" {
  description = "Conexão com o Redshift"
  name        = "redshift_secret_${random_string.unique_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.redshift_connection.id
  secret_string = jsonencode({
    username            = aws_redshift_cluster.this.master_username
    password            = aws_redshift_cluster.this.master_password
    engine              = "redshift"
    host                = aws_redshift_cluster.this.endpoint
    port                = tostring(var.redshift_port)
    dbClusterIdentifier = aws_redshift_cluster.this.cluster_identifier
  })
}
