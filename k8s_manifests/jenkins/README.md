### Jenkins on Kubernetes
* Nice [article](https://akomljen.com/set-up-a-jenkins-ci-cd-pipeline-with-kubernetes/) about standard Jenkins
* Use “scripted” over “declarative” pipeline
* Use route53 to create **a** record (jenkins.domain.com -> IP)
* Label the node where you want jenkins to be installed: `k label node node-name jenkins=yes`
* Run on that particular node:
	* `sudo mkdir /jenkins_home`
	* `sudo chown 1000:1000 /jenkins_home/`
* Install 7 plugins respectively: Build Timeout, Timestamper, Pipeline, Pipeline Stage View, Git, Github, Matrix Authorization Strategy
* ⚠️ With GlusterFS Jenkins is working slow
* Set up password during registration
* Get an jenkins init password: `kubectl exec --namespace='jenkins' jenkins-pod -c jenkins -it cat /var/jenkins_home/secrets/initialAdminPassword`
* ⚠️Hit `http://localhost:8080/restart` if Jenkins shows blank web page
