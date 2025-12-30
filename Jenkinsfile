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
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                bat "mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=${SONAR_TOKEN_3}"
            }
        }

        stage('Snyk SCA Scan') {
            steps {
                bat "mvn io.snyk:snyk-maven-plugin:2.0.0:check"
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Run ZAP DAST') {
            steps {
                bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                bat "docker run -d --name testproject -p 8080:8080 ${DOCKER_IMAGE}"
                bat "timeout /t 15"
                bat "cd /d \"${ZAP_PATH}\" && zap.bat -cmd -quickurl http://localhost:8080 -quickout \"%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html\""
                bat "docker stop testproject && docker rm testproject"
            }
        }

        stage('Push Docker Image') {
            steps {
                bat "docker push ${DOCKER_IMAGE}"
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
