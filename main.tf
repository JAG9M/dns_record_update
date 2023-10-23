## create SSM document
provider "aws" {
  region = "us-east-1"
}

resource "aws_ssm_document" "MyAnsiblePlaybookdocument" {
  name          = "ansiblePlaybook_document"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2",
    description   = "Run Ansible playbook",
    mainSteps = [
      {
        action = "aws:runShellScript",
        name   = "runShellScript",
        inputs = {
          runCommand = [
            "ansible-playbook /home/ec2-user/ansible/roles/patching/al2/patching.yml"
          ]
        }
      }
    ]
  })
}

## Create SSM association
resource "aws_ssm_association" "MyAnsiblePlaybookassociation" {
  name = aws_ssm_document.MyAnsiblePlaybookdocument.name
  targets {
    key    = "InstanceIds"
    values = ["i-0f31e5d5ed8f515bb"]
  }
}
