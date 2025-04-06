output "db_url" {
  value = aws_db_instance.salon_db.endpoint
}
output "db_pass" {
  value = local.db_creds.password
}
output "db_user" {
  value = local.db_creds.username
}