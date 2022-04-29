#Security Keys
resource "tls_private_key" "esg-instance-keys" {
  algorithm = "RSA"
}

resource "aws_key_pair" "esg-ppk-keys" {
  key_name   = "esgapps"
  public_key = tls_private_key.esg-instance-keys.public_key_openssh
}

resource "aws_kms_key" "kms_key_encryption" {
	enable_key_rotation = true
  deletion_window_in_days = 10
}

resource "aws_security_group" "vpc-security" {
  name        = "ESG-VPC-Security-Group"
  vpc_id      = aws_vpc.ESG_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}