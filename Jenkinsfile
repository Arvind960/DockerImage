pipeline {
    agent any

    environment {
        IMAGE_NAME = 'asjsr/nginx-custom:latest'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🔧 Building Docker Image..."
                    sh 'docker build -t nginx-custom .'
                }
            }
        }

        stage('Run and Test Container') {
            steps {
                script {
                    echo "🚀 Running Container for Testing..."
                    sh 'docker run -d --name test-nginx -p 8081:80 nginx-custom'
                    sh 'sleep 5'

                    def statusCode = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8081', returnStdout: true).trim()
                    echo "✅ HTTP Status Code: ${statusCode}"

                    if (statusCode != '200') {
                        error("❌ Container test failed with status code ${statusCode}")
                    }
                }
            }
        }

        stage('Tag and Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        echo "📦 Tagging and Pushing Docker Image to DockerHub..."
                        sh '''
                            docker tag nginx-custom $IMAGE_NAME
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push $IMAGE_NAME
                            docker logout
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo "🧹 Cleaning up..."
            sh 'docker rm -f test-nginx || true'
        }
        success {
            echo "🎉 Build and Push Completed Successfully!"
        }
        failure {
            echo "⚠️ Build Failed. Cleanup done."
        }
    }
}
