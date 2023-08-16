output "master_ip" {
  value = aws_instance.master_node.public_ip
}

output "slave_ip_1" {
  value = aws_instance.slave_node_1.public_ip
}

output "slave_ip_2" {
  value = aws_instance.slave_node_2.public_ip
}