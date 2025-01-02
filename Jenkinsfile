pipeline {
    agent any  // This runs on any available agent in Jenkins

    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
                // Add your build commands here, for example:
                // sh './gradlew build'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Add your test commands here, for example:
                // sh './gradlew test'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Add your deployment commands here, for example:
                // sh './gradlew deploy'
            }
        }
    }
}
