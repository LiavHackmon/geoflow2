resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = [
                aws_subnet.private.id,
                aws_subnet.private_2.id
               ]

  tags = {
    Name = "Postgres subnet group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier         = "asterra-postgres"
  engine             = "postgres"
  engine_version     = null
  instance_class     = "db.t3.micro"  
  allocated_storage  = 20
  storage_type       = "gp2"
  username           = var.db_username
  password           = var.db_password   
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]  
  skip_final_snapshot = true
  publicly_accessible = false
  tags = {
    Name = "asterra-db"
  }
}

