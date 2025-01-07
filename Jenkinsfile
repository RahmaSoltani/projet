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
                    bat 'gradle clean test'
                    bat 'gradle jacocoTestReport'
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'build/reports/tests/test/*.xml', onlyIfSuccessful: true
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'build/reports/cucumber/*.html', onlyIfSuccessful: true
                    junit'**/build/test-results/test/*.xml'
                    cucumber '**/reports/*.json'

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
                    bat 'gradle jar'
                    bat 'gradle javadoc'
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'build/libs/*.jar', onlyIfSuccessful: true
                }
            }
        }
stage('Send Notification') {
            steps {
                script {
                    def result = currentBuild.result ?: 'SUCCESS'
                    if (result == 'SUCCESS') {
                        mail to: 'lo_soltani@esi.dz',
                             subject: "Jenkins Build #${env.BUILD_NUMBER} Success",
                             body: "The build #${env.BUILD_NUMBER} was successful.\n\nCheck it out: ${env.BUILD_URL}"
                    } else {
                        mail to: 'lo_soltani@esi.dz',
                             subject: "Jenkins Build #${env.BUILD_NUMBER} Failure",
                             body: "The build #${env.BUILD_NUMBER} failed.\n\nCheck it out: ${env.BUILD_URL}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }

        success {
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
