pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube'  // The name of your SonarQube server configured in Jenkins
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"  // Ensure Gradle is in the PATH
        MAVEN_REPO_URL = credentials('repoUrl')  // Your Maven repository URL credential ID
        MAVEN_USERNAME = credentials('repoUser')  // Your Maven repository username credential ID
        MAVEN_PASSWORD = credentials('repoPassword')  // Your Maven repository password credential ID
    }

    stages {

        stage('Test') {
            steps {
                script {
                    echo 'Running unit tests...'
                    bat 'gradle clean test'  // Running unit tests with Gradle
                    bat 'gradle jacocoTestReport'  // Generating Jacoco test coverage report
                }
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        bat 'gradle sonarqube'  // Running SonarQube analysis using Gradle
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    def qualityGate = waitForQualityGate()  // Wait for the quality gate result from SonarQube
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
                    echo 'Building the project...'
                    bat 'gradle build'  // Running Gradle build task to compile and create the JAR file
                }
            }
        }

        stage('Deploy to Maven Repository') {
            steps {
                script {
                    echo 'Deploying JAR to Maven repository...'

                    // Use withCredentials to handle credentials securely
                    withCredentials([usernamePassword(credentialsId: 'repoCredentials', usernameVariable: 'MAVEN_USERNAME', passwordVariable: 'MAVEN_PASSWORD')]) {
                        // Upload the generated JAR file using curl
                        bat """
                        curl -u ${MAVEN_USERNAME}:${MAVEN_PASSWORD} -T build\\libs\\my-app.jar ${MAVEN_REPO_URL}
                        """
                    }
                }
            }
        }
    }
}
