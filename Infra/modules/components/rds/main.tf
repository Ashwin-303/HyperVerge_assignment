data "aws_subnet" "private" {
  count = length(var.private_subnets)
  id    = element(var.private_subnets, count.index)
}

data "aws_subnet" "public" {
  count = length(var.public_subnets)
  id    = element(var.public_subnets, count.index)
}

data "aws_subnet" "database" {
  count = length(var.database_subnets)
  id    = element(var.database_subnets, count.index)
}

resource "aws_db_subnet_group" "rds_sg" {
  name       = "${var.project_prefix}_${var.env}_rds_private_sg"
  subnet_ids = var.database_subnets

  tags = merge(
    var.tags,
    {
      "Name" = "${var.project_prefix}-${var.env}-subnet-group"
    },
  )
}



# create security group and allow all private subnet group
resource "aws_security_group" "rds_sg" {
  name   = "${var.project_prefix}_${var.env}_rds_sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_subnet.private[*].cidr_block
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_subnet.public[*].cidr_block
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_subnet.database[*].cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_subnet.database[*].cidr_block
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier        = var.identifier
  allocated_storage = var.rds.allocated_storage
  engine            = var.rds.engine
  engine_version    = var.rds.engine_version
  instance_class    = var.rds.instance_class
  name              = var.rds.name
  username          = var.rds_username
  password          = var.rds_password
  # parameter_group_name = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_sg.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags = merge(
    var.tags,
    {
      "Name" = format("healthlink-%s-db", var.env)
    },
  )
}
