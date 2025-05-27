pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                retry(3) {
                    sh 'docker build -t nginx-custom:latest .'
                }
                sh 'docker images | grep nginx-custom'
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    docker run -d --name test-nginx -p 8081:80 nginx-custom
                    sleep 5
                    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081)
                    echo "HTTP Status Code: $STATUS_CODE"
                    docker rm -f test-nginx
                    if [ "$STATUS_CODE" -ne 200 ]; then
                        echo "Health check failed!"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "Docker image built and tested successfully!"
        }
        failure {
            echo "Docker image build or test failed!"
        }
    }
}
