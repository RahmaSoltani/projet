pipeline {
    agent any  // Use any available agent

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
        }

        stage('Code Coverage') {
            steps {
                script {
                    // Generate Jacoco code coverage report
                    sh './gradlew jacocoTestReport'
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace or take any actions after pipeline execution
            cleanWs()
        }

        success {
            // Actions for a successful pipeline
            echo 'Pipeline succeeded!'
        }

        failure {
            // Actions for a failed pipeline
            echo 'Pipeline failed!'
        }
    }
}
