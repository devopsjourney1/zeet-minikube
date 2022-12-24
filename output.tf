output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_lightsail_instance.server.public_ip_address
}