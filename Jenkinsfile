pipeline {
    agent any
    environment {
        // Append the Gradle bin directory to the existing PATH
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"
    }
    stages {
        stage('Check Gradle Version') {
            steps {
                script {
                    bat 'gradle build'  // This will use Gradle from the added path
                }
            }
        }
    }
}
