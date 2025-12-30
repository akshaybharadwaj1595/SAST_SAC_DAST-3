pipeline {
    agent any

    environment {
        SONAR_TOKEN_3 = credentials('SONAR_TOKEN_3')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                bat "mvn sonar:sonar -Dsonar.login=%SONAR_TOKEN_3%"
            }
        }

        stage('Snyk Scan') {
            steps {
                bat 'mvn snyk:test'
            }
        }

        stage('ZAP DAST') {
            steps {
                bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                bat 'cd /d "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0" && zap.bat -cmd -quickurl https://www.example.com -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t catheren/testproject:latest .'
            }
        }

        stage('Docker Run') {
            steps {
                bat 'docker run -d -p 8080:8080 catheren/testproject:latest'
            }
        }
    }
}
