pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    environment {
        JAR_NAME = "my-web-app.jar"
        PROJECT_DIR = "target"
        APP_PORT = "8081"
        APP_PID_FILE = ".app.pid"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/your-user/my-web-app.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Stop Previous Instance') {
            steps {
                script {
                    if (fileExists(env.APP_PID_FILE)) {
                        def pid = readFile(env.APP_PID_FILE).trim()
                        sh "kill -9 $pid || true"
                        sh "rm -f ${env.APP_PID_FILE}"
                    }
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    def jarPath = "${env.PROJECT_DIR}/${env.JAR_NAME}"
                    sh "nohup java -jar ${jarPath} > app.log 2>&1 & echo \$! > ${env.APP_PID_FILE}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Application started on port ${env.APP_PORT}"
        }
        failure {
            echo "❌ Build or deployment failed."
        }
    }
}
