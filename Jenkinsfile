pipeline {
    agent any

    environment {
        MAVEN_REPO_URL = 'https://mymavenrepo.com/repo/wfeEoJVTqyCrSb3fpohC/'
        MAVEN_USER = 'myMavenRepo'
        MAVEN_PASSWORD = '12345678'
    }

    stages {
        // Test Stage
        stage('Test') {
            steps {
                script {
                    // Run unit tests
                    sh './gradlew test'
                }
            }
            post {
                always {
                    // Archive test results
                    junit '**/build/test-*.xml'
                    cucumber '**/build/reports/cucumber/*.json'
                }
            }
        }

        // Code Analysis Stage
        stage('Code Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    sh './gradlew sonarqube'
                }
            }
        }

        // Quality Gates Stage
        stage('Code Quality') {
            steps {
                script {
                    // Check SonarQube Quality Gate status
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality gate failed: ${qualityGate.status}"
                    }
                }
            }
        }

        // Build Stage
        stage('Build') {
            steps {
                script {
                    // Build the jar and documentation
                    sh './gradlew build'
                }
            }
            post {
                always {
                    // Archive jar and documentation
                    archiveArtifacts artifacts: '**/build/libs/*.jar, **/build/docs/**/*.html', allowEmptyArchive: true
                }
            }
        }

        // Deploy Stage
        stage('Deploy') {
            steps {
                script {
                    // Deploy to Maven repository
                    sh './gradlew publish'
                }
            }
        }

        // Notification Stage
        stage('Notification') {
            steps {
                script {
                    // Send success notifications to Slack and Email
                    slackSend channel: '#devops', message: "Build and deployment successful for version ${env.VERSION}"
                    emailext subject: "Deployment Successful", body: "Your build was successfully deployed!", to: 'lr_soltani@esi.dz'
                }
            }
        }
    }

    post {
        failure {
            // In case of failure, notify failure
            slackSend channel: '#devops', message: "Build failed for version ${env.VERSION}"
            emailext subject: "Build Failed", body: "Your build failed.", to: 'your-email@example.com'
        }
    }
}
