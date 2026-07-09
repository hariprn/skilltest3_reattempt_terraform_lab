output "public_ip" {

  description = "EC2 Public IP"

  value = aws_instance.nginx.public_ip

}

output "website_url" {

  description = "Nginx Website URL"

  value = "http://${aws_instance.nginx.public_ip}"

}

output "detected_public_ip" {

  description = "Detected Client Public IP"

  value = chomp(data.http.myip.response_body)

}

output "ubuntu_ami" {

  description = "Ubuntu AMI used"

  value = data.aws_ami.ubuntu.id

}
