pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: "main", credentialsId: 'git-cred', url: 'https://github.com/Raja-Thota/cicd-jenkins.git'
            }
        }
}
}