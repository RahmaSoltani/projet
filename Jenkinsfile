pipeline {
    agent any

    environment {
        GRADLE_HOME = tool 'Gradle' // Ensure Gradle is installed on Jenkins
    }

    stages {
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                bat "${GRADLE_HOME}\\bin\\gradle test"
                junit '**/build/test-results/test/*.xml' // Archive test results
            }
        }
    }
}
