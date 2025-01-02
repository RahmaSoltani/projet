pipeline {
    agent any
    environment {
        MAVEN_REPO_URL = 'https://mymavenrepo.com/repo/wfeEoJVTqyCrSb3fpohC/'
        MAVEN_USER = 'myMavenRepo'
        MAVEN_PASSWORD = '12345678'
    }
    stages {
        stage('Test') {
            steps {
                script {
                    sh './gradlew test'
                }
            }
            post {
                always {
                    junit '**/build/test-*.xml'
                    cucumber '**/build/reports/cucumber/*.json'
                }
            }
        }
        stage('Code Analysis') {
            steps {
                script {
                    sh './gradlew sonarqube'
                }
            }
        }
        stage('Code Quality') {
            steps {
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality gate failed: ${qualityGate.status}"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh './gradlew build'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '**/build/libs/*.jar, **/build/docs/**/*.html', allowEmptyArchive: true
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh './gradlew publish'
                }
            }
        }
        stage('Notification') {
            steps {
                script {
                    slackSend channel: '#devops', message: "Build and deployment successful for version ${env.VERSION}"
                    emailext subject: "Deployment Successful", body: "Your build was successfully deployed!", to: 'lr_soltani@esi.dz'
                }
            }
        }
    }
    post {
        failure {
            slackSend channel: '#devops', message: "Build failed for version ${env.VERSION}"
            emailext subject: "Build Failed", body: "Your build failed.", to: 'lr_soltani@esi.dz'
        }
    }
}
