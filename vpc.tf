resource "aws_vpc" "myvpc" {
  cidr_block            = "20.0.0.0/16"
  instance_tenancy      = "default"
  enable_dns_support    = "true"
  enable_dns_hostnames  = "true"
 
  tags = {
    Name                = "terraformVPC"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "20.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name                  = "terraformSubnet"
  }
}

resource "aws_internet_gateway" "myIGW" {

    vpc_id     = aws_vpc.myvpc.id


    tags = {

        Name   = "terraformIGW"
    }
}

#creating route table
resource "aws_route_table" "myRT" {

    vpc_id = aws_vpc.myvpc.id
    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIGW.id
    }


    tags = {

        Name = "TerraformRT"
    }

}

resource "aws_route_table_association" "myRTA" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myRT.id
}
