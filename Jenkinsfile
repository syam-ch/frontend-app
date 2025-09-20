Jenkinsfile:
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        S3_BUCKET = 'my-frontend-bucket'
    }
    stages {
        stage('Checkout') {
            steps { git branch: 'main', url: 'https://github.com/your-repo/frontend.git' }
        }
        stage('Build React') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }
        stage('Deploy to S3') {
            steps {
                sh 'aws s3 sync build/ s3://$S3_BUCKET --delete'
                sh 'aws cloudfront create-invalidation --distribution-id <CF_DIST_ID> --paths "/*"'
            }
        }
    }
}
