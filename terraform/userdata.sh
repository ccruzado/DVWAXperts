#!/bin/bash
yum update -y
yum install docker -y
usermod -a -G docker ec2-user
newgrp docker
systemctl enable docker.service
systemctl start docker.service
docker run --rm -it -p 80:80 vulnerables/web-dvwa