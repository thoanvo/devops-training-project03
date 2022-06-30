
[![Build Status](https://dev.azure.com/thoanvo/Ensuring%20Quality%20Releases%20Project/_apis/build/status/thoanvo.devops-training-project03%20(1)?branchName=main)](https://dev.azure.com/thoanvo/Ensuring%20Quality%20Releases%20Project/_build/latest?definitionId=3&branchName=main)


# Table of Contents - Ensuring Quality Releases

- **[Overview](#Overview)**
- **[Dependencies](#Dependencies)**
- **[Azure Resources](#Azure-Resources)**
- **[Installation Configuration Steps](#Installation-Configuration-Steps)**
- **[Monitoring And Logging Result](#Monitoring-And-Logging-Result)**
- **[Clean Up](#Clean-Up)**

## Overview

This project demonstrates how to ensure quality releases using Azure cloud through the implementation of automated testing, performance monitoring and logging using Azure DevOps, Apache JMeter, Selenium, Postman and Terraform.

* To use  a variety of industry leading tools, especially Microsoft Azure, to create disposable test environments and run a variety of automated tests with the click of a button.


![intro](./screenshots/intro.png)

## Dependencies
| Dependency | Link |
| ------ | ------ |
| Terraform | https://www.terraform.io/downloads.html |
| JMeter |  https://jmeter.apache.org/download_jmeter.cgi|
| Postman | https://www.postman.com/downloads/ |
| Python | https://www.python.org/downloads/ |
| Selenium | https://sites.google.com/a/chromium.org/chromedriver/getting-started |
| Azure DevOps | https://azure.microsoft.com/en-us/services/devops/ |

## Azure Resources
 - Azure account  
 - Azure Storage account (resource)
 - Azure Log Workspace (resource)
 - Terraform Service principle (resource)
 - Azure CLI (resource)

## Installation Configuration Steps
### Terraform in Azure
1. Clone source repo
2. Open a Terminal in VS Code and connect to your Azure Account and get the Subscription ID

```bash
az login 
az account list --output table
```

3. Configure storage account to Store Terraform state

  Execute the script **terraform/commands.sh** :

  ```bash
  ./commands.sh
  ```

  * Take notes of **storage_account_name**, **container_name**, **access_key** . They are will be used in **main.tf** terrafrom files

  ```bash
    backend "azurerm" {
      storage_account_name = "thoanvttstorage01999"
      container_name       = "thoanvttcontainer01999"
      key                  = "terraform.tfstate"
      access_key           = <access_key_value>
    }
  ```

  ![azurerm-backend](./screenshots/azurerm-backend.png)

### Create a Service Principal for Terraform
1. Create a  Service Principal with **Contributor** role, performing the following steps:

```bash
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<your-subscription-id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }" 
```

  * Take notes of **appId**, **password**, and **tenant** as will be used at **terraform/terraform.tfvars** file 


2. On your terminal create a SSH key and also perform a keyscan of your github to get the known hosts.

  ```bash
  ssh-keygen -t rsa
  cat ~/.ssh/id_rsa.pub
  ```

### Azure DevOps
1. Login to Azure DevOPs and perform the following settings before to execute the Pipeline. 

2. Install these Extensions :

  * JMeter (https://marketplace.visualstudio.com/items?itemName=AlexandreGattiker.jmeter-tasks&targetId=625be685-7d04-4b91-8e92-0a3f91f6c3ac&utm_source=vstsproduct&utm_medium=ExtHubManageList)
    
  * PublishHTMLReports (https://marketplace.visualstudio.com/items?itemName=LakshayKaushik.PublishHTMLReports&targetId=625be685-7d04-4b91-8e92-0a3f91f6c3ac&utm_source=vstsproduct&utm_medium=ExtHubManageList)

  * Terraform (https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks&targetId=625be685-7d04-4b91-8e92-0a3f91f6c3ac&utm_source=vstsproduct&utm_medium=ExtHubManageList)

3. Create a Project into your Organization

4. Create the Service Connection in Project Settings > Pipelines > Service Connection

    ![service-connection](screenshots/service-connection.png) <br/>
 
5. Add into Pipelines --> Library --> Secure files these 2 files:
  * The private secure file : **id_rsa key**
  * The terraform tfvars file : **terraform.tfvars**

    ![library-secure-files](./screenshots/library-secure-files.png)

6. Modify the following lines on azure-pipelines.yaml before to update your own repo:
    * Get your "Known Hosts Entry" is the displayed third value that doesn't begin with # in the GitBash results:<br/>
    
    ```bash
    ssh-keyscan github.com
    ```
    * Take note value in highlight below to fill **knownHostsEntry**

    ![azurerm-backend](screenshots/ssh-keyscan.png)

    | # #  | parameter | description |
    | ------ | ------ | ------ |
    | 1| knownHostsEntry |  the knownHost of your ssh-keyscan github |
    | 2 | sshPublicKey |  your public ssh key (from id_rsa.pub) |
    | 3 | storageAccountName | Value from Configure storage account to Store Terraform state |

7. Create groups of variables
  Create groups of variables that you can share across multiple pipelines. 
  * Choose "+Variable groups" > Add name groups of variables : ssh-config > Add **knownHostsEntry**, **sshPublicKey**, **StorageAccountName** and value this in Variables > Select type to secret > Save <br/>
  ![screen shot](screenshots/variable-group.png) <br/>  

8. Create a New Pipeline in your Azure DevOPs Project
  - Located at GitHub
  - Select your Repository
  - Existing Azure Pipelines YAML file
  - Choosing **azure-pipelines.yaml** file

    8.1. Tab Pipelines -> Create Pipeline -> Where is your code? Choose Github (Yaml) -> Select Repo -> Configure your pipeline
    : Choose "Existing Azure Pipelines yaml file" > Continue > Run <br/>
      ![img](screenshots/select-existing-yaml-file.png) <br/>

      ![img](screenshots/run-pipeline.png) <br/>

    8.2. Apcept permission for Azure Resources Create with terraform <br/>
      ![img](screenshots/permission-needed.png) <br/>

      ![img](screenshots/permission-permit.png) <br/>

    8.3. When step deploy virtual machine(VM) if you can see error : "No resource found ...". you must Registration VM on environment Pipeline and you only need to run it once (from 8.4 to 8.6) <br/>

      ![img](screenshots/devops-error-no-resource.png) <br/>

    8.4. Go to Azure pipeline -> Environments -> you can see Environments name is "TEST" -> Choose and select "Add resource" -> choose "Virtual machines" > Select "Linux" and Choose icon "Copy command ..." > Close <br>
    Something similar to </br>
      ![img1](screenshots/devops-add-resource.png) </br>
      ![img2](screenshots/devops-add-resource-script.png)

    8.5. SSH into the VM created using the Public IP -> Enter command you just copy above step -> Run it -> Success if you see result like this 
    ![img3](screenshots/devops-excute-add-resource-script.png) <br>
      
    ![img4](screenshots/excute-script-in-vm.png)

    Get at the end a result like:

    ![img5](screenshots/devops-result-add-resource-vm.png)

    8.6. Back to pipeline and re-run


9. Wait the Pipeline is going to execute on the following Stages:

    Azure Resources Create --> Build --> Deploy App --> Test

    ![img](./screenshots/automation-test-result.png)

### Configure Logging for the VM in the Azure Portal
1. Create a Log Analytics workspace. It will be created on the same RG used by terraform

    ![img](./screenshots/log-analytics-workspace.png)

2. Set up email alerts in the App Service:
 
 * Log into Azure portal and go to the AppService that you have created.
 * On the left-hand side, under Monitoring, click Alerts, then New Alert Rule.
 * Verify the resource is correct, then, click “Add a Condition” and choose Http 404
 * Then, set the Threshold value of 1. Then click Done
 * After that, create an action group and name it myActionGroup, short name mag.
 * Then, add “Send Email” for the Action Name, and choose Email/SMS/Push/Voice for the action type, and enter your email. Click OK
 * Name the alert rule Http 404 errors are greater than 1, and leave the severity at 3, then click “Create”
  Wait ten minutes for the alert to take effect. If you then visit the URL of the app service and try to go to a non-existent page more than once it should trigger the email alert.

3. Log Analytics
  * Go to the `App service* Diagnostic Settings > + Add Diagnostic Setting`. Tick `AppServiceHTTPLogs` and Send to Log Analytics Workspace created on step above and  `Save`. 

  * Go back to the `App service > App Service Logs `. Turn on `Detailed Error Messages` and `Failed Request Tracing` > `Save`. 
  * Restart the app service.

4. Set up log analytics workspace properly to get logs:

  * Go to Virtual Machines and Connect the VM created on Terraform to the Workspace ( Connect). Just wait that shows `Connected`.

    * Set up custom logging , in the log analytics workspace go to Advanced Settings > Data > Custom Logs > Add > Choose File. Select the file selenium.log > Next > Next. Put in the following paths as type Linux:

    /var/log/selenium/selenium.log

    Give it a name ( `selenium_logs_CL`) and click Done. Tick the box Apply below configuration to my linux machines.

  * Go to the App Service web page and navigate on the links and also generate 404 not found , example:

    ```html
    https://udacity-thoanvtt-project03-app-appservice.azurewebsites.net

    https://udacity-thoanvtt-project03-app-appservice.azurewebsites.net/gggg  ( click this many times so alert will be raised too)
    ```

  * After some minutes ( 3 to 10 minutes) , check the email configured since an alert message will be received. and also check the Log Analytics Logs , so you can get visualize the logs and analyze with more detail.

  ![img](screenshots/azure-monitor-alert-triggered.png)


## Monitoring And Logging Result
Configure Azure Log Analytics to consume and aggregate custom application events in order to discover root causes of operational faults, and subsequently address them.

### Environment Creation & Deployment
  #### The pipeline build results page
  ![Pipeline-Result](screenshots/automation-test-result.png)

  #### Terraform Init
  ![Terraform](screenshots/terraform-init-in-pipeline.png)

  #### Terraform Validate
  ![Terraform](screenshots/terraform-validate-in-pipeline.png)

  #### Terraform Plan
  ![Terraform](screenshots/terraform-plan-in-pipeline-1.png) <br>

  ![Terraform](screenshots/terraform-plan-in-pipeline-2.png) <br>

  #### Terraform Apply
  ![Terraform](screenshots/terraform-apply-in-pipeline-1.png) <br>

  ![Terraform](screenshots/terraform-apply-in-pipeline-2.png) <br>
### Automated Testing

  #### FakeRestAPI
  ![DeployWebApp](screenshots/deploy-azure-web-app.png)

  ![FakeRestAPI](screenshots/fakerestapi.png)

  #### JMeter log output
  ![JMeterLogOutput](screenshots/jmeter-log-output-stress-test.png)

  ![JMeterLogOutput](screenshots/jmeter-log-output-endurance-test.png)

  #### JMeter Endurance Test                                                                      
  ![Endurance test](screenshots/publish-endurance-test-results.png)

  #### JMeter Stress Test
  ![Stress test](screenshots/publish-stress-test-results.png)

  #### Selenium
  ![Selenium test](screenshots/selenium-logging.png)

  ![Selenium test](screenshots/selenium-logging.png)

  #### Regression Tests
  ![Regression test](screenshots/test-run-regression-postman.png)

  ![Regression test](screenshots/junit-regression-test-summary.png)

  ![Regression test](screenshots/junit-regression-test-result.png)

  #### Validation Tests
  ![Validation test](screenshots/test-run-validation-postman.png)

  ![Validation test](screenshots/junit-validation-test-summary.png)

  ![Validation test](screenshots/junit-validation-test-result.png)

  #### The artifact is downloaded from the Azure DevOps and available under the /projectartifactsrequirements folder.



### Monitoring & Observability

  #### Alert Rule:
  ![Alert Rule](screenshots/404-alert-rule.png)

  ![The Triggered Alert](screenshots/the-alert-triggered.png)


  #### Triggered Alert:
  ![Triggered Email Alert](screenshots/azure-monitor-alert-triggered.png)

  ![The Graphs 404 Alert](screenshots/azure-alert-rule.png)

  #### Logs from Azure Log Analytics
    
    Go to Log Analytics Workspace , to run the  following queries:

    ```kusto
    AppServiceHTTPLogs
    | where TimeGenerated < ago(2h)
      and ScStatus == '404'
    ```

  ![Log Analytics](screenshots/app-service-http-logs.png)
    
## Clean Up

* On Az DevOps Pipeline , give approval on the notification to resume with the Destroy Terraform Stage.



