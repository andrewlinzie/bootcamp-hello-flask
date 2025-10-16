pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'us-east-1'
    AWS_ACCOUNT_ID     = '899631475351'
    ECR_REPO           = 'bootcamp-project-app'
    IMAGE_TAG          = "${env.BUILD_NUMBER}"
    CLUSTER_NAME       = 'bootcamp-project-eks'
    CHART_NAME         = 'hello'
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/andrewlinzie/bootcamp-hello-flask.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh '''
          docker build -t $ECR_REPO:$IMAGE_TAG .
          docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Push to ECR') {
      steps {
        script {
          sh '''
          aws ecr get-login-password --region $AWS_DEFAULT_REGION \
            | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
          docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy to EKS via Helm') {
      steps {
        script {
          sh '''
          aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_DEFAULT_REGION
          helm upgrade --install $CHART_NAME ./helm-chart \
            --set image.repository=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPO \
            --set image.tag=$IMAGE_TAG \
            --set service.type=LoadBalancer \
            --set service.port=80
          '''
        }
      }
    }
  }

  post {
    always {
      sh 'docker system prune -af || true'
    }
  }
}
