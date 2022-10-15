################################
# Setup AWS CLI
################################

export AWS_ACCESS_KEY_ID="$1"
export AWS_SECRET_ACCESS_KEY="$2"
export AWS_SESSION_TOKEN="$3"


################################
# Deploy Infra
################################
echo "Deploying infra"

git clone "https://github.com/anthonysarkis/LOG8415-Assignment-1.git"

cd LOG8415-Assignment-1
cd Terraform
terraform init
terraform apply -auto-approve

export url=$(terraform output --raw alb_dns_name)
export load_balancer=$(terraform output --raw load_balancer_arn_suffix)
export cluster1=$(terraform output --raw M4_group_arn_suffix)
export cluster2=$(terraform output --raw T2_group_arn_suffix)
cd ..
cd ..

echo "Infra deployed"

################################
# Send Requests
################################

docker pull wayr/ec2_requests:latest

echo "Launching requests"
docker run -e url="$url" wayr/ec2_requests:latest
echo "Requests completed"

################################
# Get Benchmark
################################

docker pull wayr/ec2_benchmarks:latest

echo "Launching benchmarks"
docker run \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN" \
    -e load_balancer="$load_balancer" \
    -e cluster1="$cluster1" \
    -e cluster2="$cluster2" \
    wayr/ec2_benchmarks:latest
echo "Benchmarks completed"

$SHELL