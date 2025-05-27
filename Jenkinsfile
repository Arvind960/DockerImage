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
                sh 'docker build -t nginx-custom:latest .'
                sh 'docker images | grep nginx-custom'
            }
        }
        
        stage('Test Container') {
            steps {
                sh '''
                    docker run -d --name test-nginx -p 8081:8081 nginx-custom
                    sleep 5
                    curl -s -o /dev/null -w "%{http_code}\\n" http://localhost:8081
                    docker rm -f test-nginx
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
