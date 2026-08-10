resource "aws_vpc" "main" {
  cidr_block = "10.42.0.0/16"

  tags = {
    Name       = "benchmark-vpc"
    SubnetList = join(",", aws_subnet.private[*].id)
  }
}

resource "aws_subnet" "private" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = "us-east-1a"
}
