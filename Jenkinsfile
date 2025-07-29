pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'v1'
    }

    tools {
        // These names should be configured in Jenkins global tool settings
        maven 'Maven_3.8.1'
        jdk 'JDK11'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/NAVIN132/BoardGame-Source.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Optional: Stop previous containers
                    sh "docker rm -f ${IMAGE_NAME} || true"
                    dockerImage.run("-d --name ${IMAGE_NAME} -p 8080:8080")
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and container run successful!'
        }
        failure {
            echo '❌ Build failed.'
        }
        cleanup {
            script {
                node {
                    echo "🧹 Cleanup: List all Docker containers"
                    sh 'docker ps -a'
                }
            }
        }
    }
}
