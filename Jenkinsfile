pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_LOGIN = credentials('SONAR_TOKEN_3') // Jenkins credential
    }

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

        stage('Security Scans') {
            stages {

                stage('Snyk Container') {
                    steps {
                        bat '"C:\\snyk\\snyk-win.exe" container test asecurityguru/testeb || exit /b 0'
                    }
                }

                stage('Snyk SCA') {
                    steps {
                        bat 'mvn snyk:test -fn || exit /b 0'
                    }
                }

                stage('ZAP DAST') {
                    steps {
                        bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                        bat 'cd /d "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0" && zap.bat -cmd -quickurl http://localhost:8080 -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"'
                    }
                }

                stage('Checkov') {
                    steps {
                        bat '"C:\\Users\\Akshay Bharadwaj\\AppData\\Roaming\\Python\\Python313\\Scripts\\checkov.exe" -s -f main.tf || exit /b 0'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                bat 'mvn sonar:sonar -Dsonar.projectKey=TestProject -Dsonar.host.url=%SONAR_HOST_URL% -Dsonar.login=%SONAR_LOGIN%'
            }
        }
    }
}
