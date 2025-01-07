pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube'  // The name of your SonarQube server configured in Jenkins
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"  // Ensure Gradle is in the PATH
         MAVEN_REPO_URL = credentials('repoUrl')
         MAVEN_USERNAME = credentials('repoUser')
         MAVEN_PASSWORD = credentials('repoPassword')

    }

    stages {

        stage('Test') {
            steps {
                script {
                    echo 'Running unit tests...'
                    bat 'gradle clean test'  // Running unit tests
                    bat 'gradle jacocoTestReport'  // Generating Jacoco test coverage report
                }
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        bat 'gradle sonarqube'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality Gate failed. Stopping pipeline."
                    } else {
                        echo "Quality Gate passed."
                    }
                }
            }
        }
        stage('Build') {
             steps {
                  script {
                      echo 'Running unit tests...'
                      bat 'gradle build'

                  }
             }
        }
        stage('Deploy to Maven Repository') {
            steps {
                script {
                    // Use curl to upload the JAR file to your Maven repository
                    echo 'Deploying JAR to Maven repository...'
                    bat """
                    curl -u ${MAVEN_USERNAME}:${MAVEN_PASSWORD} -T build\\my-app.jar ${MAVEN_REPO_URL}
                    """
                }
            }
        }



    }
}
