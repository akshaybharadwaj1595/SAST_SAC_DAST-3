pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t catheren/testproject:latest .'
            }
        }

        stage('ZAP DAST') {
            steps {
                bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                bat 'cd /d "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0" && zap.bat -cmd -quickurl http://localhost:8080 -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_HOST_URL = 'http://localhost:9000'
                SONAR_LOGIN = 'your_sonar_token'
            }
            steps {
                bat 'mvn sonar:sonar -Dsonar.projectKey=TestProject -Dsonar.host.url=%SONAR_HOST_URL% -Dsonar.login=%SONAR_LOGIN%'
            }
        }
    }
}
