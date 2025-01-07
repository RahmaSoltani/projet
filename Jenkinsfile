pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube' // The name configured in Step 2
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"

    }



    stages {

        stage('test') {
            steps {
                script {
                    echo 'Running test...'
                    bat 'gradle clean test'
                    bat 'gradle jacocoTestReport'
                }
            }
        }
        stage('Code Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        bat 'gradle sonarqube'
                    }



                }
            }
        }
        stage('Quality Gate') {
                    steps {
                        script {
                            // Step 2: Wait for SonarQube Quality Gate
                            def qualityGate = waitForQualityGate()
                            if (qualityGate.status != 'OK') {
                                error "Quality Gate failed. Stopping pipeline."  // Fail the pipeline if Quality Gate fails
                            }
                        }
                    }




    }
}
