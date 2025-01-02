pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your repository
                git 'https://github.com/RahmaSoltani/projet'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Run the Gradle build
                    sh './gradlew build'
                }
            }
        }

        stage('Unit Tests') {
            steps {
                script {
                    // Run unit tests
                    sh './gradlew test'
                }
            }

            post {
                success {
                    // Archive unit test results
                    archiveArtifacts artifacts: '**/build/test-results/test/TEST-*.xml', allowEmptyArchive: true

                    // Generate Cucumber reports
                    cucumber buildStatus: 'UNSTABLE', fileIncludePattern: '**/build/reports/cucumber/*.json'
                }
                failure {
                    // If tests fail, send failure notification (Slack or Email handled by Jenkins settings)
                    slackSend channel: '#your-channel', color: 'danger', message: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Code Coverage') {
            steps {
                script {
                    // Generate Jacoco code coverage report
                    sh './gradlew jacocoTestReport'
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    // Publish to Maven repository
                    sh './gradlew publish'
                }
            }

            post {
                success {
                    // Send success notification to Slack (if you use Jenkins to handle this automatically, this is not needed)
                    slackSend channel: '#your-channel', color: 'good', message: "Build Successful: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                }
                failure {
                    // Send failure notification to Slack
                    slackSend channel: '#your-channel', color: 'danger', message: "Publish Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            // Always run cleanup tasks if needed
        }
    }
}
