#!/bin/bash

yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
docker pull linuxdynasty/urlshortner
export DATABASE_URL="postgresql://dev:${DB_PASSWORD}@${DB_HOST}/DB"
docker run -d -p 80:5001 --restart=always -e DATABASE_URL=$DATABASE_URL linuxdynasty/urlshortner
