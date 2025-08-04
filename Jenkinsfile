pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
        MAVEN_HOME = "/opt/maven"
        PATH = "${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${env.PATH}"
        DEPLOY_DIR = "/opt/app"
        APP_PORT = "8085"
    }

    tools {
        maven 'Maven'     // Define this in Jenkins Global Tool Config
        jdk 'Java_Home'   // Define this in Jenkins Global Tool Config
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/NAVIN132/BoardGame-Source.git', branch: 'master'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean install'
            }
        }


        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Trivy Scan') {
            steps {
                echo "🔍 Running Trivy scan on the project"
                sh '''
                    if ! command -v trivy &> /dev/null; then
                        echo "Installing Trivy..."
                        sudo apt-get update
                        sudo apt-get install -y wget apt-transport-https gnupg lsb-release
                        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
                        echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
                        sudo apt-get update
                        sudo apt-get install -y trivy
                    fi

                    echo "Scanning with Trivy..."
                    trivy fs --security-checks vuln,secret --exit-code 0 --severity HIGH,CRITICAL .
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo "📦 Deploying app to ${DEPLOY_DIR}"
                sh '''
                    echo "📁 Creating deployment directory..."
                    sudo mkdir -p ${DEPLOY_DIR}

                    echo "📥 Copying jar..."
                    sudo cp target/*.jar ${DEPLOY_DIR}/app.jar
                    sudo chown -R jenkins:jenkins ${DEPLOY_DIR}

                    echo "📝 Writing systemd service..."
                    sudo bash -c 'cat > /etc/systemd/system/app.service <<EOF
                [Unit]
                Description=Spring Boot Application
                After=network.target
                
                [Service]
                User=jenkins
                WorkingDirectory='${DEPLOY_DIR}'
                ExecStart=/usr/bin/java -jar '${DEPLOY_DIR}'/app.jar --server.port='${APP_PORT}'
                SuccessExitStatus=143
                Restart=always
                RestartSec=5
                StandardOutput=append:'${DEPLOY_DIR}'/app.log
                StandardError=append:'${DEPLOY_DIR}'/app-error.log
                
                [Install]
                WantedBy=multi-user.target
                EOF'
                                '''
                            }
                        }

        stage('Run App') {
            steps {
                echo "🚀 Running app from ${DEPLOY_DIR} on port ${APP_PORT}"
                sh '''
                    echo "🔄 Reloading systemd..."
                    sudo systemctl daemon-reload

                    echo "✅ Restarting app.service..."
                    sudo systemctl enable app.service
                    sudo systemctl restart app.service

                    echo "📄 Tail logs..."
                    sleep 5
                    sudo tail -n 20 ${DEPLOY_DIR}/app.log

                    echo "🌐 App should be running at http://<EC2_PUBLIC_DNS>:${APP_PORT}"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline succeeded."
        }
        failure {
            echo "❌ CI/CD Pipeline failed."
        }
    }
}
