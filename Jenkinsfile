pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    bat 'gradle build'  // Use 'bat' for Windows
                }
            }
        }
    }
}
