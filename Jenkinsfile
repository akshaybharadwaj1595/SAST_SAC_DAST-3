pipeline {
    agent any

    tools {
        maven 'Maven_3_8_7'
    }

    environment {
        DOCKER_IMAGE = "catheren/testproject"
    }

    stages {

        /* =========================
           BUILD + SONAR ANALYSIS
           ========================= */
        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'SONAR_TOKEN_3', variable: 'SONAR_TOKEN')]) {
                        bat """
                        mvn clean verify ^
                        org.sonarsource.scanner.maven:sonar-maven-plugin:3.11.0.3922:sonar ^
                        -Dsonar.login=%SONAR_TOKEN% ^
                        -Dsonar.projectKey=TestProject ^
                        -Dsonar.host.url=http://localhost:9000 ^
                        -Dmaven.test.failure.ignore=true
                        """
                    }
                }
            }
        }

        /* =========================
           QUALITY GATE (BLOCKER)
           ========================= */
        stage('Sonar Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        /* =========================
           DOCKER BUILD
           ========================= */
        stage('Docker Build') {
            steps {
                withDockerRegistry([credentialsId: 'dockerlogin', url: '']) {
                    script {
                        docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                    }
                }
            }
        }

        /* =========================
           SECURITY SCANS
           ========================= */
        stage('Security Scans') {

            stages {

                stage('Snyk Container Scan') {
                    steps {
                        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                            bat """
                            C:\\Users\\jcath\\Downloads\\Snyk\\snyk-win.exe container test ${DOCKER_IMAGE}:${BUILD_NUMBER} || exit /b 0
                            """
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
                        bat """
                        cd /d "C:\\Users\\jcath\\Downloads\\Snyk\\ZAP_2.15.0_Crossplatform\\ZAP_2.15.0" ^
                        && zap.bat -cmd ^
                        -quickurl http://3.85.51.191:8080/ ^
                        -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"
                        """
                    }
                }

                stage('Checkov') {
                    steps {
                        bat """
                        "C:\\Users\\jcath\\AppData\\Roaming\\Python\\Python313\\Scripts\\checkov.exe" ^
                        -s -f main.tf || exit /b 0
                        """
                    }
                }
            }
        }
    }

    /* =========================
       POST ACTIONS
       ========================= */
    post {
        always {
            archiveArtifacts artifacts: 'ZAP_Reports/ZAP_Output.html', allowEmptyArchive: true
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
        success {
            echo '✅ Pipeline completed successfully.'
        }
    }
}
