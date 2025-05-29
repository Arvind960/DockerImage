pipeline {
    agent any

    environment {
        IMAGE_BASE = 'asjsr/nginx-custom'
    }

    stages {
        stage('Read Version') {
            steps {
                script {
                    VERSION = readFile('VERSION').trim()
                    IMAGE_TAG = "${IMAGE_BASE}:${VERSION}"
                    env.IMAGE_TAG = IMAGE_TAG // Export for next stages
                    echo "📦 Using image tag: ${IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(env.IMAGE_TAG)
                }
            }
        }

        stage('Run and Test Container') {
            steps {
                sh 'docker rm -f test-nginx || true'
                sh "docker run -d --name test-nginx -p 8081:80 ${env.IMAGE_TAG}"
                sh 'sleep 5'

                script {
                    def statusCode = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8081', returnStdout: true).trim()
                    if (statusCode != '200') {
                        error("❌ Container test failed with status code ${statusCode}")
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    def image = docker.image(env.IMAGE_TAG)
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                        image.push()
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker rm -f test-nginx || true'
        }
        success {
            echo "✅ Image pushed: ${env.IMAGE_TAG}"
        }
        failure {
            echo "⚠️ Build failed."
        }
    }
}
