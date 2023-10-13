
variable "private_cidr_blocks" {
  type = list(string)
  default = ["10.0.0.0/8", "172.16.0.0/16"]
}

resource "aws_route_table" "gwlbe_subnet1_rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  # Use a for loop to create routes for the additional private CIDRs
  for cidr_block in var.private_cidr_blocks {
    route {
      cidr_block = cidr_block
      gateway_id = aws_transit_gateway.transit_gateway1.id
    }
  }

  tags = {
    Name = "GWLBe Subnet 1 Route Table"
    Network = "Private"
  }
}

resource "aws_route_table" "nat_gw_subnet1_rtb" {
  vpc_id = var.vpc_id
  
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  # Use a for loop to create routes for the additional private CIDRs
  for cidr_block in var.private_cidr_blocks {
    route {
      cidr_block = cidr_block
      vpc_endpoint_id = aws_vpc_endpoint.gwlb_endpoint1.id
    }
  }
 
  tags = {
    Name = "NAT Subnet 1 Route Table"
    Network = "Public"
  }
}
