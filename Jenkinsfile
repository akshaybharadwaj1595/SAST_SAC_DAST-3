pipeline {
    agent any
    environment {
        SONAR_TOKEN_3 = credentials('SONAR_TOKEN_3')
        DOCKER_IMAGE = "catheren/testproject:latest"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN_3}"
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
                // Optionally push to registry:
                // sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('ZAP DAST') {
            steps {
                bat 'if not exist "%WORKSPACE%\\ZAP_Reports" mkdir "%WORKSPACE%\\ZAP_Reports"'
                bat 'cd /d "C:\\ZAP\\ZAP_2.16.0_Crossplatform\\ZAP_2.16.0" && zap.bat -cmd -quickurl http://localhost:8080 -quickout "%WORKSPACE%\\ZAP_Reports\\ZAP_Output.html"'
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'ZAP_Reports/*.html', allowEmptyArchive: true
        }
    }
}
