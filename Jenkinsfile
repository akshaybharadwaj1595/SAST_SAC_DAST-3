pipeline {
    agent any

    tools {
        maven 'Maven_3_8_7'
    }

    stages {

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN_3', variable: 'SONAR_TOKEN')]) {
                    bat "mvn -B verify sonar:sonar -Dsonar.login=%SONAR_TOKEN% -Dsonar.projectKey=TestProject -Dsonar.host.url=http://localhost:9000/"
                }
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
                        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                            bat '"C:\\snyk\\snyk-win.exe" container test catheren/testproject || exit /b 0'
                        }
                    }
                }

                stage('Snyk SCA') {
                    steps {
                        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                            bat 'mvn snyk:test -fn || exit /b 0'
                        }
                    }
                }

                stage('ZAP DAST') {
                    steps {
                        bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                        bat 'cd /d "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0" && zap.bat -cmd -quickurl https://www.example.com -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"'
                    }
                }

                stage('Checkov') {
                    steps {
                        bat '"C:\\Users\\Akshay Bharadwaj\\AppData\\Roaming\\Python\\Python313\\Scripts\\checkov.exe" -s -f main.tf || exit /b 0'
                    }
                }

            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'ZAP_Reports/ZAP_Output.html', allowEmptyArchive: true
        }
    }
}
