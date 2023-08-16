resource "aws_security_group" "postgresql_sg" {
  name        = "postgresql_sg"
  description = "sg for postgresql communicate with each other"
  vpc_id      = aws_vpc.database_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true          # Allows PostgreSQL traffic from the same security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "postgresql_sg"
  }
}


resource "aws_security_group" "cassandra_sg" {
  name        = "Cassandra_sg"
  description = "sg for Cassandra communicate with each other"
  vpc_id      = aws_vpc.database_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    self        = true          # For node-to-node communication.
  }

  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    self        = true          # or client-to-node communication.
  }

  ingress {
    from_port   = 7199
    to_port     = 7199
    protocol    = "tcp"
    self        = true          # For JMX (Java Management Extensions).
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Cassandra_sg"
  }
}
