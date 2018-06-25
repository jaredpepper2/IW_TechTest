# IW Technical Test
Below is a summary of the solution I have put together for the IW technical test.

## Found Issue's
1. Updates are required on the server
2. OS has surpassed end of life
3. Apache permissions are set to 777.
4. Login is permitted for root user.

## The Solution
Using **Ansible 2.5.4** I have created a playbook that uses **6** separate Ansible roles to, upgrade packages, monitor metrics, fix found issues, upgrade OS, report deployments and change the Apache configs. The roles are stated below:

### Common Role
- Upgrades all packages on the host.
### Monitoring Roles
- Prints a summary of metrics to the console.
### Fix Issues
- Corrects the Apache files to have 755 permissions and not 777.
- Prevents login for the root user.
### Upgrade EOL Role
- Upgrades all packages on the host.
- Makes sure update manager is installed on the host.
- Reboots the server.
- Waits for the server to stand back up.
### Slack Role
- Posts Failed, Initiated and Completed deployments on the host.  
### Update Apache Config Role
- Update the Apaches configs using Ansible templates.

## Reporting Errors
All reports are posted to the **Leeodisuniversity.slack.com** channel. All Slack posts will either go to the **#failed_deployments** channel or the **#all_deployments** channel. Below is a list of the posts that are automated into the Slack channel:

- Any deployment/configuration which is **performed** on the host via Ansible, is posted to Slack.
- Any deployment/configuration which is **completed** on the host via Ansible, is posted to Slack
- Any tasks that **fail** are posted to Slack. Failed reports in Slack will state:

      1. The task the Ansible script failed on.
      2. The action being performed by Ansible, when the task failed.
      3. The error message.

*A invite to the Slack channel will be provided with the compiled solution. If you find that the invite to the Slack channel has expired, then please do not hesitate to contact me at jaredpepper2@gmail.com for a new invite.*

## How to Perform Changes on the Host
Running the following script will perform all automated deployments that are described in the playbook onto the target host. The script takes one argument, which is the file location of the hosts private key. Below is an example on how to run the script:

**Command to Run:**
- *Configure_Leodis_Server.sh [Private key (PEM) file location]*

**Example:**
- *Configure_Leodis_Server.sh /home/user/Documents/PrivateKey.pem*

**Requirements:**
- Please make sure you run the script as your local user and not as root.
- Please state the full path of the the .pem file.

### What the Script Will Do
1. Installs Git & Ansible on the local machine.
2. Creates a 'Ansible' folder in your users document folder
3. Pulls the latest version of this repo into the created 'Documents/Ansible' folder.
4. Runs the FixServer.yml playbook.
5. The FixServer.yml playbook then performs deployments on the host.

### The Script Presumes:
1. You are running the script as your local user.
2. You are passing in the correct .pem file location (State the full path of the .pem file).
3. Your user account has a *'Documents'* folder under the path location of */home/'your user'/*.

## Performing Apache Config Changes
Apache config changes can easily be performed by changing the template files in this git repository. Once the changes have been performed via Git, then the *Configure_Leodis_Server.sh [Private key (PEM) file location]* script can be run again, and the config changes will then push through onto the server.

## Alternative Approach
The ansible-pull feature could have been used from the host server. Ansible-pull could have been configured to pull this repository from the host server. Ansible-pull could have run on a schedule, so that deployments could have been performed often.

## Testing Approach
The playbook was tested on a t2.micro instance, booted up from from my personal AWS account. The test server is still listed in the *hosts* file.

## To Do:
- Ansible Vault: Variable for Slack Token
- Change condition back to 12.04 in EoL role
