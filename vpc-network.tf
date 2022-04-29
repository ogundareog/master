# Configure the AWS Provider VPC Network
# VPC Network
resource "aws_vpc" "ESG_vpc" {
      cidr_block = "100.50.0.0/16"
      instance_tenancy = "default"
      tags = {
          Name  = "ESG_Prod_VPC"
          Service = "Production"
      }
}

#ESG VPC Internet Gateway
resource "aws_internet_gateway" "ESG_gw" {
  vpc_id = aws_vpc.ESG_vpc.id

  tags = {
    Name = "ESG_inet_gw"
  }
}

#ESG VPC Public Subnet 1
resource "aws_subnet" "ESG_Public_subnet-1" {
  vpc_id     = aws_vpc.ESG_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "100.50.3.0/24"

  tags = {
    Name = "ESG_Public_subnet-1"
    Service = "Production"
  }
}

#ESG VPC Public Subnet 2
resource "aws_subnet" "ESG_Public_subnet-2" {
  vpc_id     = aws_vpc.ESG_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "100.50.4.0/24"

  tags = {
    Name = "ESG_Public_subnet-2"
    Service = "Production"
  }
}

resource "aws_route_table" "ESG-publicrtb" {
  vpc_id = aws_vpc.ESG_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ESG_gw.id
  }
    tags = {
    Name = "ESG Public Route Table"
  }
}

resource "aws_route_table_association" "publicrtb1_assoc" {
  subnet_id      = aws_subnet.ESG_Public_subnet-1.id
  route_table_id = aws_route_table.ESG-publicrtb.id
}
resource "aws_route_table_association" "publicrtb2_assoc" {
  subnet_id      = aws_subnet.ESG_Public_subnet-2.id
  route_table_id = aws_route_table.ESG-publicrtb.id
}

#ESG VPC Private Subnet 1
resource "aws_subnet" "ESG_Priv_subnet-1" {
  vpc_id     = aws_vpc.ESG_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "100.50.1.0/24"

  tags = {
    Name = "ESG_Prod_subnet-1"
    Service = "Production"
  }
}

#ESG VPC Private Subnet 2
resource "aws_subnet" "ESG_Priv_subnet-2" {
  vpc_id = aws_vpc.ESG_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "100.50.2.0/24"

  tags = {
    Name = "ESG_Prod_subnet-2"
    Service = "Production"
  }
}

resource "aws_eip" "nat_gateway-1" {
  vpc = true
}

resource "aws_eip" "nat_gateway-2" {
  vpc = true
}
resource "aws_nat_gateway" "ESG-Priv_subnet-1-Nat" {
  connectivity_type = "public"
  allocation_id = aws_eip.nat_gateway-1.id
  subnet_id         = aws_subnet.ESG_Priv_subnet-1.id
  depends_on = [aws_internet_gateway.ESG_gw]
}

resource "aws_nat_gateway" "ESG-Priv_subnet-2-Nat" {
  connectivity_type = "public"
  allocation_id = aws_eip.nat_gateway-2.id
  subnet_id         = aws_subnet.ESG_Priv_subnet-2.id
  depends_on = [aws_internet_gateway.ESG_gw]
}

#Route Table for ESG VPC Private Subnet 1
resource "aws_route_table" "ESG_Subnet-1-route_table" {
  vpc_id = aws_vpc.ESG_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ESG-Priv_subnet-1-Nat.id
  }
    tags = {
    Name = "ESG Priv-Subnet-1 Route Table"
  }
}

#Route Table for ESG VPC Private Subnet 2
resource "aws_route_table" "ESG_Subnet-2-route_table" {
  vpc_id = aws_vpc.ESG_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ESG-Priv_subnet-2-Nat.id
  }
    tags = {
    Name = "ESG Priv-Subnet-2 Route Table"
  }
}


#Route Table Association for ESG_Priv_subnet-1
resource "aws_route_table_association" "ESG_Priv-subnet-1-route_table-association" {
  subnet_id      = aws_subnet.ESG_Priv_subnet-1.id
  route_table_id = aws_route_table.ESG_Subnet-1-route_table.id
}

#Route Table Association for ESG_Priv_subnet-2
resource "aws_route_table_association" "ESG_Priv-subnet-2-route_table-association" {
  subnet_id      = aws_subnet.ESG_Priv_subnet-2.id
  route_table_id = aws_route_table.ESG_Subnet-2-route_table.id
}


