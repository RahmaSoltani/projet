pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh './gradlew test' // Run unit tests
                junit 'build/test-results/**/*.xml' // Archive test results
                cucumber build 'build/cucumber-reports/' // Generate Cucumber reports
            }
        }
        stage('Code Analysis') {
            steps {
                echo 'Analyzing code quality...'
                sh './gradlew sonarqube' // Run SonarQube analysis
            }
        }
        stage('Code Quality') {
            steps {
                echo 'Checking Quality Gates...'
                script {
                    def qg = waitForQualityGate() // Check Quality Gate status
                    if (qg.status != 'OK') {
                        error "Pipeline aborted due to quality gate failure: ${qg.status}"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building project...'
                sh './gradlew build' // Build project JAR
                archiveArtifacts artifacts: 'build/libs/*.jar' // Archive JAR
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying artifact...'
                sh './gradlew publish' // Deploy JAR to MyMavenRepo
            }
        }
        stage('Notification') {
            steps {
                echo 'Sending notifications...'
                mail to: 'team@example.com',
                     subject: "Build Success",
                     body: "The pipeline executed successfully!"
            }
        }
    }
    post {
        failure {
            mail to: 'team@example.com',
                 subject: "Build Failure",
                 body: "The pipeline failed during execution."
        }
    }
}
