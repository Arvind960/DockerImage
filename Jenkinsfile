pipeline {
    agent any

    environment {
        IMAGE_NAME = 'asjsr/nginx-custom:latest'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "🔧 Building Docker Image..."
                sh 'docker build -t nginx-custom .'
            }
        }

        stage('Run and Test Container') {
            steps {
                echo "🛑 Removing existing container if it exists..."
                sh 'docker rm -f test-nginx || true'

                echo "🚀 Running container for testing..."
                sh 'docker run -d --name test-nginx -p 8081:80 nginx-custom'
                sh 'sleep 5'

                script {
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
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                        sh """
                            docker tag nginx-custom $IMAGE_NAME
                            docker push $IMAGE_NAME
                        """
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
            echo "🎉 Build and Push completed successfully!"
        }
        failure {
            echo "⚠️ Build failed. Cleanup done."
        }
    }
}
