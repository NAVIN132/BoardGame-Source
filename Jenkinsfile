pipeline {
    agent any

    tools {
        maven 'Maven3' // Must match the name in Global Tool Configuration
    }

    environment {
        JAR_NAME = "my-web-app.jar"       // Change this if your JAR has a different name
        JAR_PATH = "target/my-web-app.jar"
        PID_FILE = ".app.pid"
        LOG_FILE = "app.log"
        APP_PORT = "8080"
    }

    stages {
        stage('Clone from Git') {
            steps {
                git url: 'https://github.com/NAVIN132/BoardGame-Source.git', branch: 'master'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Stop Existing App (if running)') {
            steps {
                script {
                    if (fileExists(env.PID_FILE)) {
                        def pid = readFile(env.PID_FILE).trim()
                        echo "Stopping app running with PID: $pid"
                        sh "kill -9 $pid || true"
                        sh "rm -f ${env.PID_FILE}"
                    } else {
                        echo "No previous instance found."
                    }
                }
            }
        }

        stage('Run New App') {
            steps {
                script {
                    sh """
                        nohup java -jar ${env.JAR_PATH} > ${env.LOG_FILE} 2>&1 &
                        echo \$! > ${env.PID_FILE}
                    """
                    echo "✅ App started on port ${env.APP_PORT}, PID written to ${env.PID_FILE}"
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment complete. App should be running at http://<EC2-PUBLIC-IP>:8080"
        }
        failure {
            echo "❌ CI/CD Pipeline Failed."
        }
    }
}
