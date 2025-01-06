pipeline {
    agent any

    environment {
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"
    }

    stages {
        stage('Test') {
            steps {
                echo 'Running Unit Tests...'
                bat 'gradle test'
            }
        }




}
