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

                    // Archive test result artifacts
                    archiveArtifacts artifacts: '**/build/test-logs/*.xml', allowEmptyArchive: true

                    // Run cucumber reports generation
                    bat "gradle jacocoTestReport"

                    // Archive cucumber report artifacts
                    archiveArtifacts artifacts: 'build/reports/cucumber/example-report.json', allowEmptyArchive: true
                }

            }

        }
         stage('Code Analysis') {
                    steps {
                        script {
                            // Run SonarQube analysis
                            bat 'gradle sonarqube -Dsonar.host.url=http://197.140.142.82:9000/'
                        }
                    }
                }
    }
}
