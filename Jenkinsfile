pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    bat './gradlew build'  // Use 'bat' for Windows
                }
            }
        }
    }
}
