pipeline {
    agent any
    environment {
        // Append the Gradle bin directory to the existing PATH
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"
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
