#!/bin/bash
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get install cloud-utils
sudo docker pull wayr/ec2_flask:latest
EC2_INSTANCE_ID=$(ec2metadata --instance-id)
EC2_TYPE=$(ec2metadata  --instance-type)
sudo docker run -e instanceId="$EC2_INSTANCE_ID / $EC2_TYPE" -d -p 80:5000 wayr/ec2_flask
