# Set up private Docker registry
* Create Amazon ECR and follow push commands
* `aws ecr get-login --region eu-west-1 --profile aracki`
* Login to Docker ECR; Build -> Tag -> Push
* Create [regcred](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-secret-in-the-cluster-that-holds-your-authorization-token) secret with user/pwd from get-login output command
* Add imagePullSecrets to Deployment which will pull image from ECR
