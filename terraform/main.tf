provider "aws" {
  region = var.zone
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
  availability_zone       = "${var.zone}a"

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
  availability_zone       = "${var.zone}b"

  tags = {
    Name        = "${var.prefix}-subnet-2"
    Environment = "Dev"
  }

  depends_on = [aws_vpc.this]
}

resource "aws_subnet" "third" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.redshift_subnet_cidr_third
  map_public_ip_on_launch = true
  availability_zone       = "${var.zone}c"

  tags = {
    Name        = "${var.prefix}-subnet-3"
    Environment = "Dev"
  }

  depends_on = [aws_vpc.this]
}


resource "aws_redshift_subnet_group" "this" {
  name = "${var.prefix}-subnet-group"
  subnet_ids = [
    "${aws_subnet.first.id}",
    "${aws_subnet.second.id}",
    "${aws_subnet.third.id}"
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

resource "aws_redshiftserverless_namespace" "this" {
  namespace_name      = "dbt"
  admin_username      = var.rs_master_username
  admin_user_password = var.rs_master_password
  db_name             = var.rs_database_name
  iam_roles           = ["${aws_iam_role.redshift_role.arn}"]

  tags = {
    Name        = "${var.prefix}-redshift-namespace"
    Environment = "Dev"
  }
}

resource "aws_redshiftserverless_workgroup" "this" {
  namespace_name       = aws_redshiftserverless_namespace.this.namespace_name
  workgroup_name       = "desafio-ton"
  enhanced_vpc_routing = true
  security_group_ids   = ["${aws_security_group.this.id}"]
  subnet_ids = [
    "${aws_subnet.first.id}",
    "${aws_subnet.second.id}",
    "${aws_subnet.third.id}"
  ]

  tags = {
    Name        = "${var.prefix}-redshift-workgroup"
    Environment = "Dev"
  }
}
