#Private Key File Location
private_key="$1"
# Error Handling
PROGNAME=$(basename $0)
# Repo of Playbook
REPOSRC="https://github.com/jaredpepper2/IW_TechTest.git"

Install_Ansible()
{
  # System updates
  sudo apt-get update
  # Git
  sudo apt install -y git
  # Ansible
  sudo apt-get install -y software-properties-common
  sudo apt-add-repository -y ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get install -y ansible
}

Configure_Local_Enviroment()
{
  # Setting Up Ansible Variables
  me="$(whoami)"
  # Creates Ansible Folder on System, if it does not already exsist
  mkdir -p /home/$me/Documents/Ansible ||  error_exit "Error was at Line no: $LINENO Issue creating 'Ansible' folder."
  # Getting Latest Version of Git Repo
  LOCALREPO="/home/$me/Documents/Ansible"
  LOCALREPO_VC_DIR="$LOCALREPO"/.git
}

Pull_Playbook_From_Git()
{
  if [ ! -d "$LOCALREPO_VC_DIR" ]
  then
      cd "$LOCALREPO"
      echo "Cloning latest version of Repository"
      git clone "$REPOSRC" ||  error_exit "Error was at Line no: $LINENO Problem cloning Git Repo"
  else
      cd "$LOCALREPO"
      echo "Pulling latest version of Repository"  error_exit "Error was at Line no: $LINENO Problem Pulling Git Repo"
      git pull "$REPOSRC"
  fi
}

Check_Private_Key_Arg()
{
  if [ -z "$private_key" ]
    then
      echo "Please supply the file directory of the hosts private key file as the first argument"
      echo "Example: Configure_Leodis_Server.sh /home/user/Documents/PrivateKey.pem"
      exit 1
  fi
}

Run_PlayBook()
{
  sudo ansible-playbook "$LOCALREPO"/playbooks/FixServer.yml --private-key="$private_key"|| error_exit "Error was at Line no: $LINENO Please make sure that you are using the correct file path to the hosts private key. For example does the command resemble the following 'Configure_Leodis_Server.sh /home/user/Documents/PrivateKey.pem'"
}

error_exit()
{
  echo "Error: Error in ${PROGNAME}. ${1:- "Unknown Error"}" 1>&2
  exit 1
}

Check_Private_Key_Arg
Install_Ansible
Configure_Local_Enviroment
Pull_Playbook_From_Git
Run_PlayBook
