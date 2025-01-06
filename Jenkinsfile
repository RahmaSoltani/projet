pipeline {
    agent any

    environment {
        MYMAVENREPO_USER = credentials('repoUser') // Replace with Jenkins credential ID
        MYMAVENREPO_PASS = credentials('repoPassword') // Replace with Jenkins credential ID
    }

    stages {
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh './gradlew test' // Run unit tests
                junit '**/build/test-results/**/*.xml' // Archive test results
                cucumber 'build/reports/cucumber/*.json' // Generate Cucumber reports
            }
        }

        stage('Code Analysis') {
            steps {
                echo 'Analyzing code quality with SonarQube...'
                withSonarQubeEnv('SonarQube') { // Replace 'SonarQube' with your server configuration name
                    sh './gradlew sonarqube'
                }
            }
        }

        stage('Code Quality') {
            steps {
                echo 'Checking SonarQube Quality Gates...'
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
                echo 'Building the project...'
                sh './gradlew build' // Build and generate the JAR
                sh './gradlew javadoc' // Generate documentation
                archiveArtifacts artifacts: '**/*.jar, **/build/docs/**/*', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to MyMavenRepo...'
                sh """
                ./gradlew publish \
                -Dmymavenrepo.user=$MYMAVENREPO_USER \
                -Dmymavenrepo.password=$MYMAVENREPO_PASS
                """
            }
        }

        stage('Notification') {
            steps {
                echo 'Sending success notifications...'
                mail to: 'lr_soltani@esi.dz',
                     subject: 'Pipeline Successful',
                     body: 'The pipeline completed successfully.'
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Sending failure notifications...'
            mail to: 'lr_soltani@esi.dz',
                 subject: 'Pipeline Failed',
                 body: 'The pipeline failed. Check Jenkins for details.'
        }
    }
}
