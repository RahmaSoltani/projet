pipeline {
    agent any
    environment {
        // Append the Gradle bin directory to the existing PATH
    }
    stages {
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                bat "gradle -v"
            }
        }




    }
}
