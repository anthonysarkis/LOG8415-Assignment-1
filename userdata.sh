#!/bin/bash
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo docker pull wayr/ec2_flask:latest
sudo docker run -d -p 80:5000 wayr/ec2_flask