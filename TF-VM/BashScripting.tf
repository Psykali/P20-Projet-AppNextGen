####################
## Bash Scripting ##
####################
resource "null_resource" "install_packages_jenkins" {
  depends_on = [
    azurerm_linux_virtual_machine.vm1,
  ]
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.vm1.public_ip_address
  }

provisioner "remote-exec" {
  inline = [
        "sudo apt-get update && sudo apt-get -y upgrade",
        "sudo apt-get install -y apache2 curl",
        "sudo apt-get install -y mariadb-server",
        "sudo apt-get install -y php libapache2-mod-php php-mysql",
        "sudo apt install openjdk-8-jdk -y",
        "sudo apt install openjdk-11-jdk -y",
        "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
        "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
        "sudo apt update",
        "sudo apt install jenkins -y",
        "sudo ufw allow 8080"
  ]
  }
}
resource "null_resource" "install_packages_ansible" {
  depends_on = [
    azurerm_linux_virtual_machine.vm2,
  ]
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.vm2.public_ip_address
  }

provisioner "remote-exec" {
  inline = [
        "sudo apt-get update && sudo apt-get -y upgrade",
        "sudo apt-get install -y ansible",
        "sudo apt-get install -y apache2",
        "sudo apt-get install -y mariadb-server",
        "sudo apt-get install -y php libapache2-mod-php php-mysql",
        "sudo apt -y install docker.io"
  ]
  }
}