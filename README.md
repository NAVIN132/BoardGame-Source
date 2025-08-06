Steps  1 : Run the App Locally

1. git clone https://github.com/DevOpsInstituteMumbai-wq/Automating-Secure-Deployment-of-Board-game-Listing-WebApp-on-AWS
   cd BoardGame

2. Run the application in local host and verify that it working 

    mvn clean install
 
    mvn spring-boot:run

3. Access the Url to verify that application is running in localhost

   http://localhost:8085/


After Confirmation I push the source on my Git Hub repository : https://github.com/NAVIN132/BoardGame-Source.git


Steps  2 : Create the Infrastructure : 

1. Write all the .tf file as per project required : 

├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── ec2.tf
│   ├── alb.tf
│   ├── rds.tf

Run the terraform init command which will initate the Provide and download it in our module.

Run the terraform validate command which will validate all the configuration

Generate the .pub file using below command : 

ssh-keygen -y -f "/c/KCSWorks/DevOps/CapstoneProject/.ssh/appserverkey.pem" > "/c/KCSWorks/DevOps/CapstoneProject/.ssh/appserverkey.pub"

Again Run the terraform validate command to check every thing is ok.

Run the command terraform plan to check what plan is created and will be applied it will give the details.

Run the below command to apply the : 

terraform apply  ( Approval Require "yes"  throough prompting)

or 

terraform apply -auto-approve  ( Auto Approve ) 


2. Access the Jenkin on Url :  http://<EC2_PublicIP>:8080

     Access the EC2 Machine on Git Bash :   ssh -i "C:/KCSWorks/DevOps/CapstoneProject/AWS_Infra/.ssh/appserverkey.pem" ubuntu@<EC2_PublicIP>
     Get the Admin Initail Password of Jenkins : sudo cat /var/lib/jenkins/secrets/initialAdminPassword
     Install plug In : Stage View Pipeline  
   
3. Set the JAVA and Maven path in Jenkins : 

      Java   : To see the path : echo $JAVA_HOME
  
                Name :  Java_Home 
                JAVA_HOME : /usr/lib/jvm/java-17-openjdk-amd64

    Maven : To see Maven path : mvn -version
                Name : Maven
                MAVEN_HOME : /usr/share/maven

4.  Set the Global credentials : 
      secret text
      github

5. Install the plugin in the Jenkins : 

    Stage view 
    GitHub plugin
    GitHub Integration plugin
    Git plugin
    Pipeline plugin

6.  Configure GitHub Webhook
      Go to your GitHub repo:
    Settings → Webhooks → Add webhook

     Payload URL: http://<ec2-ip>:8080/github-webhook/
     Content type: application/json

     Event: "Just the push event"

    Save

7.  Write the CI/CD pieline Job Configuration
       
      If you’re not using a multibranch pipeline:

      Go to your Jenkins job → Configure

      Enable: "GitHub hook trigger for GITScm polling"

      After Successful JOB run access the url : http://<ec2-ip>:8085 to verify that application is running or not    
 
     optional  

     Run it manually using  Git Bash : 

     cd /opt/app
     java -jar app.jar --server.port=8085
  

7 . Output Ports & URLs to Access

Tool	Default Port	Access URL

Jenkins	   8080	http://<ec2-ip>:8080
Prometheus   9090	http://<ec2-ip>:9090
Grafana	   3000	http://<ec2-ip>:3000
Application   8085       http://<ec2-ip>:8085
Actuator        8085       http://<ec2-ip>:8085/actuator/
