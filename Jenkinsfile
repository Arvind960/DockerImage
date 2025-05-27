pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nginx-custom'
        CONTAINER_NAME = 'test-nginx'
        PORT = '8081'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Test Container') {
            steps {
                script {
                    // Remove old container if it exists
                    sh 'docker rm -f $CONTAINER_NAME || true'

                    // Run new container
                    sh 'docker run -d --name $CONTAINER_NAME -p $PORT:80 $IMAGE_NAME'

                    // Give it time to start
                    sh 'sleep 5'

                    // Test using curl
                    def status = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:$PORT", returnStdout: true).trim()
                    echo "HTTP Status Code: ${status}"

                    // Check response code
                    if (status != '200') {
                        error("App did not return 200 OK. Got: ${status}")
                    }

                    // Clean up
                    sh 'docker rm -f $CONTAINER_NAME'
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Docker image build or test failed!'
        }
        success {
            echo '✅ Docker image built and tested successfully!'
        }
    }
}
