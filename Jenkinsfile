pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "catheren/testproject:latest"
        SONAR_TOKEN_3 = credentials('SONAR_TOKEN_3')  // Make sure this credential exists in Jenkins
    }

    stages {
        stage('Clean Workspace') {
            steps {
                bat 'if exist "%WORKSPACE%\\target" rmdir /s /q "%WORKSPACE%\\target"'
            }
        }

        stage('Maven Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    bat "mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN_3}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Docker Run') {
            steps {
                bat "docker stop testproject || exit 0"
                bat "docker rm testproject || exit 0"
                bat "docker run -d --name testproject -p 8080:8080 %DOCKER_IMAGE%"
            }
        }

        stage('ZAP DAST Scan') {
            steps {
                bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                bat 'cd /d "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0" && zap.bat -cmd -quickurl http://localhost:8080 -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"'
            }
        }
    }

    post {
        always {
            bat 'docker stop testproject || exit 0'
            bat 'docker rm testproject || exit 0'
        }
    }
}
