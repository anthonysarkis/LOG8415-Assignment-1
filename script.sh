################################
# Setup AWS CLI
################################

export AWS_ACCESS_KEY_ID="$1"
export AWS_SECRET_ACCESS_KEY="$2"
export AWS_SESSION_TOKEN="$3"


################################
# Deploy Infra
################################

cd Terraform/

terraform init

terraform apply -auto-approve

export url=$(terraform output --raw alb_dns_name)
export load_balancer=$(terraform output --raw load_balancer_arn_suffix)
export cluster1=$(terraform output --raw M4_group_arn_suffix)
export cluster2=$(terraform output --raw T2_group_arn_suffix)
export M4=$(terraform output --raw M4)
export T2=$(terraform output --raw T2)

cd ..

################################
# Send Requests
################################

docker pull wayr/ec2_requests_slim:latest

docker run -e url="$url" -e invert=False  wayr/ec2_requests_slim:latest

################################
# Get Benchmark
################################

docker pull wayr/ec2_benchmarks:latest

docker run -e load_balancer="$load_balancer" -e cluster1="$cluster1" -e cluster2="$cluster2" -e M4="$M4" -e T2="$T2" wayr/ec2_benchmarks:latest

$SHELL