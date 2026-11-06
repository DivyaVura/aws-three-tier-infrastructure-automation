
output "web_asg_name" {
  description = "Name of the Web Tier Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "app_asg_name" {
  description = "Name of the Application Tier Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "web_launch_template_id" {
  description = "Web Tier Launch Template ID"
  value       = aws_launch_template.web.id
}

output "app_launch_template_id" {
  description = "Application Tier Launch Template ID"
  value       = aws_launch_template.app.id
}
