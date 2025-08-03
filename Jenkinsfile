pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
        MAVEN_HOME = "/opt/maven"
        PATH = "${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${env.PATH}"
        DEPLOY_DIR = "/opt/app"
        APP_PORT = "8085"  // change if your app runs on a different port
    }

    tools {
        maven 'Maven'   // Set in Jenkins Global Tool Config
        jdk 'Java_Home'         // Set in Jenkins Global Tool Config
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

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying JAR to $DEPLOY_DIR"

                sh """
                    echo "📁 Creating /opt/app..."
                    sudo mkdir -p /opt/app

                    echo "📦 Copying JAR to /opt/app..."
                    sudo cp target/*.jar /opt/app/app.jar
                    sudo chown -R jenkins:jenkins /opt/app

                    echo "📝 Writing app.service..."
                    sudo bash -c 'cat > /etc/systemd/system/app.service <<EOF
                    [Unit]
                    Description=Spring Boot Application
                    After=network.target
                    
                    [Service]
                    User=jenkins
                    WorkingDirectory=/opt/app
                    ExecStart=/usr/bin/java -jar /opt/app/app.jar --server.port=8085
                    SuccessExitStatus=143
                    Restart=always
                    RestartSec=5
                    StandardOutput=append:/opt/app/app.log
                    StandardError=append:/opt/app/app-error.log
                    
                    [Install]
                    WantedBy=multi-user.target
                    EOF'
                    """
            }
        }

        stage('Run App') {
            steps {
                echo "Starting app on port $APP_PORT"
                sh """
                    echo "🔄 Reloading systemd daemon..."
                    sudo systemctl daemon-reload

                    echo "✅ Enabling and restarting app.service..."
                    sudo systemctl enable app.service
                    sudo systemctl restart app.service

                    echo "🕵️ Checking logs..."
                    sleep 5
                    sudo tail -n 20 /opt/app/app.log

                    echo "🌐 App should be live at: http://<EC2_PUBLIC_DNS>:8085"
                """
                
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
