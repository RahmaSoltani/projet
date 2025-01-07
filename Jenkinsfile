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

        // Code Analysis phase
        stage('Code Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    bat 'gradle sonarqube -Dsonar.host.url=http://197.140.142.82:9000/'
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
                stage(' Notification') {
                    steps {
                        script {
                            // Deploy the .jar to Maven repository
                            //bat 'gradle  postPublishedPluginToSlack'
                              bat 'gradle  sendMailCustom'

                        }
                    }
                }


    }
}