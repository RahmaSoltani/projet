pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube'  // The name of your SonarQube server configured in Jenkins
        PATH = "C:\\gradle-8.8-bin\\gradle-8.8\\bin;${env.PATH}"  // Ensure Gradle is in the PATH
        MAVEN_REPO_URL = 'https://mymavenrepo.com/repo/wfeEoJVTqyCrSb3fpohC/'  // Your Maven repository URL credential ID
        MAVEN_USERNAME = 'myMavenRepo' // Your Maven repository username credential ID
        MAVEN_PASSWORD = '12345678'  // Your Maven repository password credential ID
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

                    bat 'gradle build'
                }
            }
        }

        stage('Build, Generate Docs, Archive and Deploy') {
            steps {
                script {
                    echo 'Building the project, generating JAR file, documentation, and deploying...'

                    // Step 1: Build the JAR file
                    bat 'gradle clean build'  // Building project to create JAR file

                    // Step 2: Generate Javadoc documentation
                    bat 'gradle javadoc'  // Running Gradle to generate Javadoc

                    // Step 3: Archive the JAR and documentation
                    archiveArtifacts artifacts: 'build/libs/*.jar', allowEmptyArchive: true  // Archive JAR file
                    archiveArtifacts artifacts: 'build/docs/javadoc/**', allowEmptyArchive: true  // Archive Javadoc

                    // Step 4: Deploy JAR file to Maven repository
                    echo 'Deploying JAR to Maven repository...'
                    withCredentials([usernamePassword(credentialsId: 'repoCredentials', usernameVariable: 'MAVEN_USERNAME', passwordVariable: 'MAVEN_PASSWORD')]) {
                        bat """
                        curl -u ${MAVEN_USERNAME}:${MAVEN_PASSWORD} -T build\\libs\\my-app.jar ${MAVEN_REPO_URL}
                        """
                    }
                }
            }
        }
    }
}
