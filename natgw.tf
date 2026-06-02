resource "aws_eip" "eks_natgw_eip_1a" {
  domain = "vpc"
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-eks_natgw_eip_1a"
    }
  )
}

resource "aws_eip" "eks_natgw_eip_1b" {
  domain = "vpc"
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-eks_natgw_eip_1b"
    }
  )
}


resource "aws_nat_gateway" "eks_natgw_1a" {
  allocation_id = aws_eip.eks_natgw_eip_1a.id
  subnet_id     = aws_subnet.eks_subnet_public_1a.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-natgw_1a"
    }
  )
}

resource "aws_nat_gateway" "eks_natgw_1b" {
  allocation_id = aws_eip.eks_natgw_eip_1b.id
  subnet_id     = aws_subnet.eks_subnet_public_1b.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-natgw_1b"
    }
  )
}

resource "aws_route_table" "eks_private_route_table_1a" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_natgw_1a.id
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-priv-route-table-1a"
    }
  )
}

resource "aws_route_table" "eks_private_route_table_1b" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_natgw_1b.id
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-priv-route-table-1b"
    }
  )
}

resource "aws_route_table_association" "eks_rtb_assoc_priv_1a" {
  subnet_id      = aws_subnet.eks_subnet_private_1a.id
  route_table_id = aws_route_table.eks_private_route_table_1a.id
}

resource "aws_route_table_association" "eks_rtb_assoc_priv_1b" {
  subnet_id      = aws_subnet.eks_subnet_private_1b.id
  route_table_id = aws_route_table.eks_private_route_table_1b.id
}