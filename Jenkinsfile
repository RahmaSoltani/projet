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

        stage('Code Quality') {
            steps {
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality Gate failed: ${qualityGate.status}"
                    }
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building the JAR file...'
                bat 'gradle jar asciidoctor'
                archiveArtifacts artifacts: 'build/libs/*.jar, build/docs/**/*.html', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to Maven Repository...'
                bat 'gradle publish'
            }
        }

        stage('Notification') {
            steps {
                echo 'Sending notification...'
                script {
                    def message = currentBuild.result == 'SUCCESS' ?
                        "Build and deployment succeeded!" :
                        "Pipeline failed at stage: ${env.STAGE_NAME}"
                    emailext subject: "Pipeline Notification",
                             body: message,
                             recipientProviders: [developers()]
                    slackSend channel: '#tp7', message: message
                }
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed!'
            emailext subject: "Pipeline Failed",
                     body: "The pipeline has failed. Please check the Jenkins logs for details.",
                     recipientProviders: [developers()]
            slackSend channel: '#tp7', message: "Pipeline failed!"
        }
    }
}
