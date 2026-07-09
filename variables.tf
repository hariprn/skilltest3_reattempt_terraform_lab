variable "region" {
  description = "AWS Region"

  type = string

  default = "ap-south-1"
}

variable "instance_type" {

  description = "EC2 Instance Type"

  type = string

  default = "t2.micro"

}
