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
  access_key = "ASIAZ3DCZEO2G2Y7GZVS"
  secret_key = "d5Rgvubav5Qe1K3dL2dy+mX/ZawTccUK6eRZbrEX"
  token      = "FwoGZXIvYXdzEOX//////////wEaDPFUwmUgluPi3I9uFCLJARgapc/wz4fc1UGEIqFqZuilxXaNtg6QNc9RiI5SaaupYsyIj4oN6ojRL84GCUj+j3VnUdevgUOzp3riGiqTl+GesR/O2758VQgjMtLdyDucNS8cwkncQlbCTn3ChZI0Zqdqg09/N6eLYCTFzfhSyGoRiCT+tLqFELDEtWVhUl1yj3NdY1FrPhVNv0S1HRmSwHqFe+SHfzNSxqpWDk37IBf/AC32ZVmKkOZcqHHs68sDdJdVzMr+KTv4Yo+AxzzUPrDW5yfpab9vRiim1q2ZBjIt5Her/4oQ0AqBSUuyuU9NGk1XBMsH0+qbbriNElNiS6TpmHbHfUB7ZLznT8ij"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}