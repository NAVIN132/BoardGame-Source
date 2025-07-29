pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'v1'
        CONTAINER_NAME = 'java-web-app'
    }

    tools {
        maven 'Maven3'        // <-- Use the actual name from Global Tool Config
        jdk 'Java 11'         // <-- Use the actual name from Global Tool Config
    }

    stages {
        stage('Checkout Master Branch') {
            steps {
                git branch: 'master', url: 'https://github.com/NAVIN132/BoardGame-Source.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Stop Existing Container') {
            steps {
                script {
                    sh """
                        if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                            docker stop ${CONTAINER_NAME} || true
                            docker rm ${CONTAINER_NAME} || true
                        fi
                    """
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    dockerImage.run("-d -p 8080:8080 --name ${CONTAINER_NAME}")
                }
            }
        }
    }

    post {
        success {
            echo '✅ CI/CD pipeline completed successfully!'
        }
        failure {
            echo '❌ Build failed. Showing logs (if any)...'
            sh "docker logs ${CONTAINER_NAME} || true"
        }
        cleanup {
            sh 'docker image prune -f'
        }
    }
}
