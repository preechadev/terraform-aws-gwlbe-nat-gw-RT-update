resource "aws_route_table" "gwlbe_subnet1_rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  # Additional routes for 10.0.0.0/8 and 172.16.0.0/16 with TGW as the next hop
  count = length(var.additional_cidrs)

  route {
    cidr_block = var.additional_cidrs[count.index]
    transit_gateway_id = aws_ec2_transit_gateway_vpc_attachment.example[count.index].id
  }

  tags = {
    Name     = "GWLBe Subnet 1 Route Table"
    Network  = "Private"
  }
}

# Create a Transit Gateway Attachment to associate the route table with the TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  vpc_id           = var.vpc_id
  transit_gateway_id = var.tgw_id
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "tgw_id" {
  description = "Transit Gateway ID"
}

variable "additional_cidrs" {
  description = "List of additional CIDRs to route to the Transit Gateway"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/16"]
}
