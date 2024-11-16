pipeline {
    agent none
    stages {
        stage('Git Checkout') {
            steps {
                git branch: "prod",url: 'https://github.com/Raja-Thota/cicd-jenkins.git'
            }
        }
}