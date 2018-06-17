# IW Technical Test
Below is a summary of the soloution I have put together for the IW technical test.

## Found Issue's
1. Updates are required on the server
2. OS has surpassed end of life

## The Soloution
Using **Ansible 2.5.4** I have created a playbook that uses **4** seperate Ansible roles to fix found issues, monitor metrics and report deployments from the AWS host.

### Common Role
- Upgrades all packages on the host.
### Monitoring Roles
- Prints a summary of metrics to the console.
### Upgrade EOL Role
- Upgrades all packages on the host.
- Makes sure update manager is installed on the host.
- Reboots the server.
- Waits for the server to stand back up.
#### Slack Role
- Posts Failed, Initiated and Completed deployments on the host.  

## Reporting Errors
- All reports are posted to the **Leeodisuniversity.slack.com** channel.
- All Slack posts will either go to the **#failed_deployments** channel or the **#all_deployments** channel.
- Any deployment/configuration which is **perfomed** on the host via Ansible, is posted to Slack.
- Any deployment/configuration which is **completed** on the host via Ansible, is posted to Slack
- Any tasks that **fail** are posted to Slack. Failed reports in Slack will state:

      1. The task the Ansible script failed on.
      2. The action being performed by Ansible, when the task failed.
      3. The error message.

*A invite to the Slack channel will be provided with the compiled soloution. If you find that the invite to the Slack channel has expired, then please do not hesitate to contact me at jaredpepper2@gmail.com for a new invite.*

## How to Perform Changes on the Host

**How to Run:**
- Run the following script: *Configure_Leodis_Server.sh* [*Private key (PEM) file location*]

**Example:**
- Configure_Leodis_Server.sh /home/user/Documents/PrivateKey.pem

**Requirements:**
- Please make sure you run the script as your local user and not as root.

### What the script will do...
1. Installs Git & Ansible on the local machine.
2. Creates a 'Ansible' folder in your users document folder
3. Pulls the latest version of this repo into the created 'Documents/Ansible' Folder.
4. Runs the FixServer.yml playbook.
5. FixServer.yml then performs deployments on the host.

### The script presumes:
1. You are running the script as your local user.
2. You are passing in the correct .pem file location.
3. Your user account has a 'Documents' folder under the path location of /home/'your user'/Documents.

## To Do:
- Find more issues
- Variable for Slack Token
- Create more roles
- Inline SSH keys
- Method to test that changes have not affected functionality
- Change condition back to 12.04 in EoL role