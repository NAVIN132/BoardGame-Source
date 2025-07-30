pipeline {
  agent any

  tools {
    maven 'Maven_3.8.1'
    jdk 'JDK11'
  }

  environment {
    JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
    PATH = "${JAVA_HOME}/bin:${env.PATH}"
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/<your-username>/<your-repo>.git'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean install'
      }
    }

    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Package') {
      steps {
        sh 'mvn package'
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }
  }
}
