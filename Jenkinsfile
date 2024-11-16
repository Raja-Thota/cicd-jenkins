pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: "main", credentialsId: 'git-cred', url: 'https://github.com/Raja-Thota/cicd-jenkins.git'
            }
        }
        stage('Maven Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Maven Test') {
            steps {
                sh 'mvn test'
            }
        }
}
}