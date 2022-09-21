terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAZ3DCZEO2BT35IN7M"
  secret_key = "zU14c9n230Ia/1lNFWxHls9d8WR7as/EhaawzL3X"
  token      = "FwoGZXIvYXdzEOj//////////wEaDNEbYcWVcsCPy9PLvyLJAcZJwalRyOp+TCd7NuelE4nHdQ6Rl++L/Ibt35AKBmSjPbsG9GocL377MzZxwsErKAjQy5LV1UdYxOtZu5A/AJ0levWbQ1D1oNX1cpgG/v4RMzPAvWOB9JXW8RIcEFEtdt0Jrw7Gk9ZIgOfurLC+S00pYwc1JbsSdlVfpOPseYpvi/bUwAle0vEh29PnEisyZAC0A+ULt08nH/AVTtATNGNevxCMvKRYZRdO8paFRFBOKVC24o0uvdbBznBN+hUdNOG89NzDFZETwSjmq66ZBjItyYSYdOiVzfO6So8uVD3mZS3vn1xpbAjoEspJHpujMOQL2QiuLFW1qKDXy4Ao"
}

resource "aws_instance" "instance1" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"

  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"

  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance3" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"

  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance4" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"

  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance5" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"

  tags = {
    Name = "M4"
  }
}