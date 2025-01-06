pipeline {
    agent any
    environment {
        MYMAVENREPO_USER = credentials('repoUser')
        MYMAVENREPO_PASS = credentials('repoPassword')
        SLACK_WEBHOOK_URL = credentials('slackWebhook')
    }
    stages {
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh './gradlew test'
                junit '**/build/test-results/**/*.xml'
                cucumber 'build/reports/cucumber/*.json'
            }
        }
        stage('Code Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh './gradlew sonarqube'
                }
            }
        }
        stage('Code Quality') {
            steps {
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Pipeline aborted due to Quality Gate failure: ${qualityGate.status}"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                sh './gradlew build'
                archiveArtifacts artifacts: '**/*.jar, **/build/docs/**/*', fingerprint: true
            }
        }
        stage('Deploy') {
            steps {
                sh "./gradlew publish -Dmymavenrepo.user=$MYMAVENREPO_USER -Dmymavenrepo.password=$MYMAVENREPO_PASS"
            }
        }
        stage('Notification') {
            steps {
                mail to: 'lr_soltani@esi.dz',
                     subject: 'Pipeline Successful',
                     body: 'The pipeline completed successfully.'
            }
        }
    }
    post {
        failure {
            mail to: 'lr_soltani@esi.dz',
                 subject: 'Pipeline Failed',
                 body: 'The pipeline failed. Check Jenkins for details.'
        }
    }
}
