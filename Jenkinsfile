pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t nginx-custom .'
                }
            }
        }

        stage('Run and Test Container') {
            steps {
                script {
                    // Run container in detached mode (keep running)
                    sh 'docker run -d --name test-nginx -p 8081:80 nginx-custom'

                    // Wait for container to start
                    sh 'sleep 5'

                    // Test HTTP status code
                    def statusCode = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8081', returnStdout: true).trim()
                    echo "HTTP Status Code: ${statusCode}"

                    if (statusCode != '200') {
                        error("Container test failed with status code ${statusCode}")
                    }
                }
            }
        }
    }

    post {
        failure {
            // Optional: cleanup on failure if you want
            sh 'docker rm -f test-nginx || true'
        }
    }
}
