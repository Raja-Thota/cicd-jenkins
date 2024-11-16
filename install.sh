sudo apt update
sudo apt upgrade -y

#Install jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt install openjdk-17-jdk -y
sudo apt-get install jenkins
sudo systemctl enables jenkins
sudo systemctl status jenkins

#Docker installation
curl https://get.docker.com | bash
sudo usermod -aG docker jenkins
newgrp docker
sudo systemctl enable docker
#######################
sudo systemctl stop jenkins
sudo systemctl start jenkins

######Start Nexus as Docker Container################
docker run -d --name nexus -p 8081:8081 -v /home/ubuntu/nexus:/nexus-data sonatype/nexus3:latest

######Start SonarQube as Docker Container################

docker run -d --name sonar -p 9000:9000 -v /home/ubuntu/sonar:/opt/sonarqube/data \
                                        -v /home/ubuntu/sonar/extension:/opt/sonarqube/extension \
                                        -v /home/ubuntu/sonar/logs:/opt/sonarqube/logs \
                                        sonarqube:lts-community

#Trivy Install
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

#Install Aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#EKSCTL Install
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

#Kubectl Install
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

#Install EKS
eksctl create cluster \
  --name my-cluster \
  --region us-east-1 \
  --version 1.28 \
  --nodegroup-name ng-high-ip \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 2 \
  --nodes-max 5 \
  --max-pods-per-node 110 \
  --ssh-access \
  --ssh-public-key git  # Replace with your SSH key name