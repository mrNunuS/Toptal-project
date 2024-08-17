resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type = "t3.micro"
  key_name      = "your-key-pair-name"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
    subnet_id                   = aws_subnet.public_subnet_a.id
  }

  user_data = <<-EOF
    #!/bin/bash
    API_ENDPOINT="${var.api_endpoint}"

    yum install -y gcc-c++ make
    curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
    yum install -y nodejs git

    git clone https://github.com/mrNunuS/Toptal-project.git /home/ec2-user/web-app
    cd /home/ec2-user/web-app
    npm install

    export PORT=8080
    export API_HOST=$API_ENDPOINT

    npm install -g pm2
    pm2 start bin/www --name "node-web-app"
    pm2 startup
    pm2 save
    EOF
}
