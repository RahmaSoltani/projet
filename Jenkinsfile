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
                    bat 'gradle jacocoTestReport'
                    archiveArtifacts artifacts: 'build/reports/cucumber/example-report.json', allowEmptyArchive: true
                }
            }
        }










    }

}