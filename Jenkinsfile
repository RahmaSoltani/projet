pipeline {
    agent any
    environment {
        MYMAVENREPO_USER = credentials('repoUser')
        MYMAVENREPO_PASS = credentials('repoPassword')
        SLACK_WEBHOOK_URL = credentials('slackWebhook')
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"
    }
    stages {
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                bat 'gradle test'
                junit '**/build/test-results/**/*.xml'
                cucumber 'build/reports/cucumber/*.json'
            }
        }

}
