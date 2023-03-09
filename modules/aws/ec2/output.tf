output "app_eip" {
  value = aws_eip.ars-eip.public_ip
}

output "app_instance" {
  value = aws_instance.ars-ec2.id
}
