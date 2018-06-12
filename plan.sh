
rm -f jenkins-training.out
rm -f terraform.tfstate

terraform plan --out="jenkins-training.out" --var "ssh_key_name=jenkins-training" --var "ssh_key_path=~/.ssh/jenkins-training.pem"
