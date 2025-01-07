pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube' // The name configured in Step 2
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"

    }



    stages {

        stage('SonarQube Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        bat 'gradle sonarqube'
                    }



                }
            }
        }


    }
}
