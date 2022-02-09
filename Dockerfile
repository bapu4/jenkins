pipeline {
    environment {
        registry = "debasish303/jenkins1_1devops"
        registryCredential = 'debasish303'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Cloning our Git') {
            steps {
                git 'git@github.com:bapu4/jenkins.git'
            }
        }
        stage('Building our image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Test jenkins1_1devops') {
                agent {
                docker { image 'debasish303/jenkins1_1devops:$BUILD_NUMBER' }
            }
            steps {
                sh 'jenkins1_1devops --version'
            }
        }
        stage('Deploy our image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Cleaning up') {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}
