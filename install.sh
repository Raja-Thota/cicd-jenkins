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