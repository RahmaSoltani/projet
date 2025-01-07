pipeline {
    agent any

    environment {
            PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"

        SONARQUBE = 'SonarQube'
        MAVEN_REPO = 'https://mymavenrepo.com/repo/wfeEoJVTqyCrSb3fpohC/'
        MAVEN_USER = 'myMavenRepo'
        MAVEN_PASSWORD = '12345678'
        EMAIL_RECIPIENT = 'lr_soltani@esi.dz'
        SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/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'
    }

    stages {
        // Test phase
        stage('Test') {
            steps {
                script {
                    // Run unit tests using Gradle
                    bat 'gradle test'

                    // Archive test reports
                    archiveArtifacts artifacts: '**/build/test-logs/*.xml', allowEmptyArchive: true

                    // Generate and archive Cucumber reports
                    bat 'gradle cucumberReports'
                    archiveArtifacts artifacts: 'build/reports/cucumber/example-report.json', allowEmptyArchive: true
                }
            }
        }

        // Code Analysis phase
        stage('Code Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    bat 'gradle sonarqube -Dsonar.host.url=http://localhost:9000'
                }
            }
        }
       /*
        // Code Quality phase
        stage('Code Quality') {
            steps {
                script {
                    // Wait for quality gate to pass
                    def qualityGateStatus = waitForQualityGate()
                    if (qualityGateStatus.status != 'OK') {
                        error "Quality Gate failed. Pipeline stopping."
                    }
                }
            }
        }
        */
        // Build phase
        stage('Build') {
            steps {
                script {
                    // Build the Jar file using Gradle
                    bat 'gradle build'

                    // Generate Javadoc
                    bat 'gradle javadoc'

                    // Archive the .jar and Javadoc files
                    archiveArtifacts artifacts: '**/build/libs/*.jar', allowEmptyArchive: true
                    archiveArtifacts artifacts: '**/build/docs/javadoc/**', allowEmptyArchive: true
                }
            }
        }

        // Deploy phase
        stage('Deploy') {
            steps {
                script {
                    // Deploy the .jar to Maven repository
                    bat 'gradle publish'
                }
            }
        }

        // Notification phase
        stage('Notification') {
            steps {
                script {
                    // Send success notification to Slack
                    slackSend(channel: '#development', message: "Deployment successful for ${env.JOB_NAME} ${env.BUILD_NUMBER}.")

                    // Send email notification
                    sendEmailNotification()
                }
            }
        }
    }

    post {
        always {
            // Run the sendMail task regardless of pipeline success or failure
            sendMailCustom()
        }

        success {
            // Notify successful pipeline run via Slack
            slackSend(channel: '#social', message: "Pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER} completed successfully.")
        }

        failure {
            // Notify failed pipeline run via Slack and send error email
            slackSend(channel: '	#social', message: "Pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER} failed.")
            sendEmailFailureNotification()
        }
    }
}

// Custom Email notification function
def sendEmailNotification() {
    mail to: EMAIL_RECIPIENT,
         subject: "Deployment Success - ${env.JOB_NAME} ${env.BUILD_NUMBER}",
         body: "The deployment has been successfully completed for ${env.JOB_NAME} ${env.BUILD_NUMBER}."
}

def sendEmailFailureNotification() {
    mail to: EMAIL_RECIPIENT,
         subject: "Deployment Failure - ${env.JOB_NAME} ${env.BUILD_NUMBER}",
         body: "The deployment has failed for ${env.JOB_NAME} ${env.BUILD_NUMBER}. Please check the Jenkins logs."
}
