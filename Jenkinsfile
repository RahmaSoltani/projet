pipeline {
    agent any

    environment {
        REPO_URL = "https://mymavenrepo.com/repo/wfeEoJVTqyCrSb3fpohC/"
        REPO_USER = "myMavenRepo"
        REPO_PASSWORD = "12345678"
    }

    stages {
        stage('Test') {
            steps {
                echo 'Running Unit Tests...'
                bat 'gradle test'
                junit '**/build/test-results/test/*.xml'
            }
        }

        stage('Code Analysis') {
            steps {
                echo 'Running Code Analysis with SonarQube...'
                withSonarQubeEnv('SonarQube') {
                    bat 'gradle sonarqube'
                }
            }
        }


}
