pipeline {
    agent any

    environment {
        SONAR_TOKEN_3 = credentials('SONAR_TOKEN_3')
        DOCKER_IMAGE = "catheren/testproject:latest"
        ZAP_PATH = "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Package') {
            steps {
                script {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    bat "mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=${SONAR_TOKEN_3}"
                }
            }
        }

        stage('Snyk SCA Scan') {
            steps {
                script {
                    bat "mvn io.snyk:snyk-maven-plugin:2.0.0:check"
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Run ZAP DAST') {
            steps {
                script {
                    bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                    // Run container in detached mode
                    bat "docker run -d --name testproject -p 8080:8080 ${DOCKER_IMAGE}"
                    // Wait for app to start
                    bat "timeout /t 15"
                    // Run ZAP scan
                    bat "cd /d \"${ZAP_PATH}\" && zap.bat -cmd -quickurl http://localhost:8080 -quickout \"%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html\""
                    // Stop and remove container
                    bat "docker stop testproject && docker rm testproject"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    bat "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning workspace...'
            deleteDir()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
