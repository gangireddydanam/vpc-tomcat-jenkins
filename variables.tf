variable "aws_region" {
	default = "us-west-1"
}

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "public_cidr" {
	type = list
	default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr" {
	type = list
	default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "data_cidr" {
	type = list
	default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
	type = list
	default = ["us-west-1b", "us-west-1c"]
}