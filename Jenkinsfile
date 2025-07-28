pipeline {
    agent any
    environment {
        TRIVY_VERSION = "0.51.1"
        DEP_CHECK_VERSION = "9.2.0"
        // INSTANCE_IP = credentials('ec2-instance-ip') // Uncomment and replace with your Jenkins credential ID
    }

    stages {
        stage('Checkout Source') {
            steps {
                echo "✅ Checking out source code..."
                checkout scm
            }
        }

        stage('Run with Maven Docker') {
            steps {
                script {
                    docker.image('maven:3.8.8-openjdk-17').inside {
                        sh 'mvn -version'
                        sh 'mvn clean install -U'
                        sh 'mvn package'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo "✅ Running Maven tests..."
                sh 'mvn test'
            }
        }

        stage('Trivy Source Scan') {
            steps {
                script {
                    echo "✅ Starting Trivy source scan..."
                    sh """
                        if [ ! -f "./trivy" ]; then
                            echo "⬇️ Trivy not found, downloading v${TRIVY_VERSION}..."
                            wget -qO trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
                            tar zxvf trivy.tar.gz
                            chmod +x trivy
                            ./trivy --version
                        else
                            echo "✅ Trivy is already downloaded."
                            ./trivy --version
                        fi

                        echo "🔍 Running Trivy scan on source with HIGH,CRITICAL severity..."
                        ./trivy fs --exit-code 0 --scanners vuln,secret,config --severity HIGH,CRITICAL .
                        echo "✅ Trivy source scan completed successfully."
                    """
                }
            }
        }

        /*
        stage('Dependency Check') {
            steps {
                withCredentials([string(credentialsId: '0dea9a63-a33d-470f-bd50-fb36a8ce8034', variable: 'NVD_API_KEY')]) {
                    script {
                        echo "✅ Starting OWASP Dependency-Check v${DEP_CHECK_VERSION}..."

                        sh '''
                            set -e
                            mkdir -p tools

                            if [ ! -d "tools/dependency-check" ]; then
                                echo "⬇️ Downloading Dependency-Check v${DEP_CHECK_VERSION}..."
                                wget -q https://github.com/jeremylong/DependencyCheck/releases/download/v${DEP_CHECK_VERSION}/dependency-check-${DEP_CHECK_VERSION}-release.zip -O tools/dependency-check.zip
                                unzip -q tools/dependency-check.zip -d tools/

                                folder=$(find tools -maxdepth 1 -type d -name "dependency-check-*")
                                if [ -n "$folder" ]; then
                                    mv "$folder" tools/dependency-check
                                else
                                    echo "❌ Error: Extracted Dependency-Check folder not found."
                                    exit 1
                                fi
                            fi

                            echo "🔍 Running Dependency-Check scan for BoardGame-App with NVD API key..."
                            tools/dependency-check/bin/dependency-check.sh \
                                --nvdApiKey $NVD_API_KEY \
                                --project "BoardGame-App" \
                                --scan . \
                                --format "HTML" \
                                --out dependency-check-report

                            echo "✅ Dependency-Check scan completed. Report: dependency-check-report/index.html"
                        '''
                    }
                }
            }
        }
        */

        /*
        stage('Deploy') {
            steps {
                echo "✅ Starting deployment to EC2..."
                sshagent(['ec2-ssh']) { // Replace 'ec2-ssh' with your SSH credential ID
                    sh 'scp target/boardgame-app.jar ec2-user@${INSTANCE_IP}:/home/ec2-user/app.jar'
                    sh 'ssh ec2-user@${INSTANCE_IP} "nohup java -jar app.jar &"'
                }
                echo "✅ Deployment completed."
            }
        }
        */
    }

    post {
        always {
            echo "✅ Archiving reports and cleaning up..."
            // archiveArtifacts artifacts: 'dependency-check-report/dependency-check-report.html', fingerprint: true
            echo "✅ Pipeline execution completed."
        }
    }
}
