pipeline {
  agent any

  tools {
    // Use Maven and JDK from Jenkins global tools
    maven 'Maven_3.8.1'
    jdk 'JDK11'
  }

  stages {
    stage('Build') {
      steps {
        sh 'mvn clean install'
      }
    }
  }
}
