pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube' // The name configured in Step 2
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"

    }

    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
                bat 'gradle build'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv(SONARQUBE_SERVER) {
                        bat 'gradle sonarqube'
                    }
                }
            }
        }


    }
}
