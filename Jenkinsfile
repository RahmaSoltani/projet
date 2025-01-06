pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    bat 'gradle -v'  // Use 'bat' for Windows
                }
            }
        }
    }
}
