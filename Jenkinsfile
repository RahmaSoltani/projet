pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube'  // The name of your SonarQube server configured in Jenkins
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"  // Ensure Gradle is in the PATH
    }

    stages {

        stage('Test') {
            steps {
                script {
                    echo 'Running unit tests...'
                    bat 'gradle clean test'  // Running unit tests
                    bat 'gradle jacocoTestReport'  // Generating Jacoco test coverage report
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
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality Gate failed. Stopping pipeline."
                    } else {
                        echo "Quality Gate passed."
                    }
                }
            }
        }
                stage('Build') {
                    steps {
                        script {
                            echo 'Running unit tests...'
                            bat 'gradle build'

                        }
                    }
                }


    }
}
