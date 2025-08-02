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
                    sudo mkdir -p $DEPLOY_DIR
                    sudo cp target/*.jar $DEPLOY_DIR/app.jar
                """
            }
        }

        stage('Run App') {
            steps {
                echo "Starting app on port $APP_PORT"

                sh """
                    # Kill previous instance if running
                    PID=\$(ps -ef | grep 'app.jar' | grep -v grep | awk '{print \$2}')
                    if [ ! -z "\$PID" ]; then
                        echo "Killing old app process \$PID"
                        kill -9 \$PID
                    fi

                    # Start new instance
                    nohup java -jar $DEPLOY_DIR/app.jar --server.port=$APP_PORT > $DEPLOY_DIR/app.log 2>&1 &
                    sleep 5
                """

                echo "✅ Application deployed and running at: http://<EC2_PUBLIC_DNS>:$APP_PORT"
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
