pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        S3_BUCKET = 'frontend-app0326'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/syam-ch/frontend-app.git',
                    credentialsId: '7184535f-c014-4ef9-8ffe-47a9b986676b'
            }
        }

        stage('Build React') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }

        stage('Deploy to S3 & Invalidate CloudFront') {
            steps {
                withAWS(credentials: '7184535f-c014-4ef9-8ffe-47a9b986676b', region: "${AWS_DEFAULT_REGION}") {
                    sh 'aws s3 sync build/ s3://$S3_BUCKET --delete'
                    sh 'aws cloudfront create-invalidation --distribution-id E1FYNFJLW218M0 --paths "/*"'
                }
            }
        }
    }
}
