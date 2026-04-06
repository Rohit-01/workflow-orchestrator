locals {
  ssh_command_value = length(trimspace(var.public_key_path)) > 0 ? "ssh -i ${pathexpand(replace(var.public_key_path, ".pub", ""))} ubuntu@${aws_instance.flask_app.public_ip}" : "terraform output -raw aws_generated_private_key_pem > flask-app-key.pem && ssh -i flask-app-key.pem ubuntu@${aws_instance.flask_app.public_ip}"
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.flask_app.public_ip
}

output "app_url" {
  description = "URL to access the Flask app"
  value       = "http://${aws_instance.flask_app.public_ip}:5000"
}

output "health_url" {
  description = "Health check URL for the Flask app"
  value       = "http://${aws_instance.flask_app.public_ip}:5000/health"
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = local.ssh_command_value
}

output "generated_private_key_pem" {
  description = "Generated private key in PEM format when no public key path is provided"
  value       = try(tls_private_key.flask_app[0].private_key_pem, null)
  sensitive   = true
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group name for the Flask app"
  value       = aws_cloudwatch_log_group.flask_app.name
}

output "cloudwatch_log_stream" {
  description = "CloudWatch log stream (EC2 instance ID)"
  value       = aws_instance.flask_app.id
}
