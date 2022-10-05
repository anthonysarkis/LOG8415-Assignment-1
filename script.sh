export AWS_ACCESS_KEY_ID="$1"
export AWS_SECRET_ACCESS_KEY="$2"
export AWS_SESSION_TOKEN="$3"


cd Terraform/

terraform init

terraform apply -auto-approve

export url=$(terraform output --raw alb_dns_name)

cd ..

docker pull wayr/ec2_requests_slim:latest

docker run -e url="$url" -e invert=False  wayr/ec2_requests_slim:latest