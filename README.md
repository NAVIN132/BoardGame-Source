=
 BOARD GAME LISTING WEBAPP - SECURE AUTOMATED DEPLOYMENT ON AWS
=

📌 PROJECT OVERVIEW
-------------------
- Application: Java Spring Boot - Board Game Listing WebApp
- Infrastructure: AWS (EC2, RDS, ALB) provisioned with Terraform
- CI/CD Pipeline: Jenkins (triggered via GitHub Webhook)
- Monitoring: Prometheus and Grafana (Docker)

STEP 1: RUN THE APPLICATION LOCALLY
------------------------------------------------------------------------------------
1. Clone the project repository:
   git clone https://github.com/DevOpsInstituteMumbai-wq/Automating-Secure-Deployment-of-Board-game-Listing-WebApp-on-AWS
   cd BoardGame

2. Build and run the application:
   mvn clean install
   mvn spring-boot:run

3. Verify the application is running:
   Open browser → http://localhost:8085/

4. Push the project to your GitHub:
   git remote set-url origin https://github.com/NAVIN132/BoardGame-Source.git
   git push origin main


STEP 2: CREATE INFRASTRUCTURE USING TERRAFORM
------------------------------------------------------------------------------------
1. File Structure:
   terraform/
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   ├── provider.tf
   ├── ec2.tf
   ├── alb.tf
   ├── rds.tf

2. Initialize Terraform:
   cd terraform
   terraform init

3. Validate configuration:
   terraform validate

4. Generate SSH public key from PEM:
   ssh-keygen -y -f "/path/to/appserverkey.pem" > "/path/to/appserverkey.pub"

5. Revalidate and review plan:
   terraform validate
   terraform plan

6. Apply the infrastructure:
   terraform apply
   # OR for auto-approval
   terraform apply -auto-approve


STEP 3: JENKINS INSTALLATION & SETUP
------------------------------------------------------------------------------------
1. Access Jenkins in browser:
   http://<EC2_Public_IP>:8080

2. SSH into EC2:
   ssh -i "/path/to/appserverkey.pem" ubuntu@<EC2_Public_IP>

3. Get initial admin password:
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword

4. Install required Jenkins plugins:
   - Git Plugin
   - GitHub Plugin
   - GitHub Integration Plugin
   - Pipeline Plugin
   - Stage View Plugin

5. Configure global tools in Jenkins:
   Java:
     Name: Java_Home
     Path: /usr/lib/jvm/java-17-openjdk-amd64

   Maven:
     Name: Maven
     Path: /usr/share/maven

6. Add global credentials in Jenkins:
   - Kind: Secret Text
   - ID: github
   - Value: Your GitHub PAT (Personal Access Token)


STEP 4: CONFIGURE GITHUB WEBHOOK
------------------------------------------------------------------------------------
1. Go to your GitHub repository → Settings → Webhooks → Add Webhook

2. Set the following:
   - Payload URL: http://<EC2_Public_IP>:8080/github-webhook/
   - Content type: application/json
   - Event: Just the push event

3. Save the webhook


STEP 5: JENKINS PIPELINE CONFIGURATION
------------------------------------------------------------------------------------
1. In Jenkins → Create a new Pipeline job (or use an existing one)

2. Configure GitHub project:
   - Enable GitHub project
   - Add repository URL

3. Under Source Code Management → Git:
   - Add your GitHub repository URL
   - Select credentials

4. Under Build Triggers:
   - Check: GitHub hook trigger for GITScm polling

5. Define pipeline using:
   - A Jenkinsfile in your repo, OR
   - Inline pipeline script

6. Save the configuration

7. Push code to GitHub → Jenkins will auto-trigger the pipeline


OPTIONAL: MANUAL APP RUN ON EC2
------------------------------------------------------------------------------------
1. SSH into the EC2 instance:
   ssh -i "/path/to/appserverkey.pem" ubuntu@<EC2_Public_IP>

2. Navigate to app directory and run:
   cd /opt/app
   java -jar app.jar --server.port=8085


STEP 6: ACCESS YOUR TOOLS & APPLICATION
------------------------------------------------------------------------------------
| Tool        | Port | URL                                |
|-------------|------|-------------------------------------|
| Jenkins     | 8080 | http://<EC2_Public_IP>:8080         |
| Application | 8085 | http://<EC2_Public_IP>:8085         |
| Actuator    | 8085 | http://<EC2_Public_IP>:8085/actuator|
| Prometheus  | 9090 | http://<EC2_Public_IP>:9090         |
| Grafana     | 3000 | http://<EC2_Public_IP>:3000         |


FINAL CHECKLIST ✅
------------------------------------------------------------------------------------
- [x] Application runs successfully on localhost
- [x] AWS infrastructure created with Terraform
- [x] Jenkins is installed and accessible
- [x] Java and Maven paths set correctly in Jenkins
- [x] GitHub webhook set and verified
- [x] CI/CD pipeline working end-to-end
- [x] Application deployed on EC2 and accessible
- [x] Monitoring tools (Prometheus/Grafana) setup


AUTHOR
------------------------------------------------------------------------------------
Name    : Navin Kumar  
GitHub  : https://github.com/NAVIN132  
Project : Automating Secure Deployment of Board Game Listing WebApp on AWS

====================================================================================
