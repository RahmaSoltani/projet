pipeline {
    agent any
    environment {
        // Append the Gradle bin directory to the existing PATH
    }
    stages {
        stage('Publish') {
            steps {
                script {
                    bat 'gradle publish'  // This will use Gradle from the added path
                }
            }
        }




    }
}
