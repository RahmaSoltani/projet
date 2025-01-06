pipeline {
    agent any

    stages {
        stage('Start') {
            steps {
                echo 'Pipeline is running...'
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo 'Running unit tests...'
                sh './gradlew test'
            }
        }
    }
}
