output "alb_sg" {
  value = aws_security_group.master_node_sg.id
}
output "front_sg" {
  value = aws_security_group.frontend_sg.id
}
output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}
output "vpc_id" {
  value = aws_vpc.cluster.id
}
