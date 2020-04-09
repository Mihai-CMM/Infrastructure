data "template_file" "init" {
depends_on = ["flexibleengine_rds_instance_v3.uipathdb"]
  template   = <<EOF
<script>
winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"} & winrm/config @{MaxEnvelopeSizekb="8000kb"}
<script>
<powershell>
netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
### remove this if you don't want to setup a password for local admin account ###
$admin = [ADSI]("WinNT://./administrator, user")
$admin.SetPassword("${var.admin_password}")
### end of remove this if you don't want to setup a password for local admin account ###
$temp = "C:\Temp"
#$link = "https://raw.githubusercontent.com/Mihai-CMM/Infrastructure/master/Setup/Install-UiPathOrchestrator.ps1"
$link = "https://raw.githubusercontent.com/UiPath/Infrastructure/master/Setup/Install-UiPathOrchestrator.ps1"
$file = "Install-UiPathOrchestrator.ps1"
New-Item $temp -ItemType directory
New-Item -Path "C:\Temp" -Name "log" -ItemType "directory"
Set-Location -Path $temp
Set-ExecutionPolicy Unrestricted -force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $link -OutFile $file
powershell.exe -ExecutionPolicy Unrestricted -File "C:\Temp\Install-UiPathOrchestrator.ps1" -orchestratorLicenseCode "${var.orchestrator_license}" -OrchestratorVersion "${var.orchestrator_versions}" -passphrase "${var.orchestrator_passphrase}" -databaseServerName  "${join(",",flexibleengine_rds_instance_v3.uipathdb.private_ips)}"  -databaseName "${var.db_name}"  -databaseUserName "${var.db_username}" -databaseUserPassword "${var.db_password}" -orchestratorAdminPassword "${var.orchestrator_password}"  -redisServerHost "${flexibleengine_compute_instance_v2.haa-master.access_ip_v4}:10000,${join(":10000,",flexibleengine_compute_instance_v2.haa-slave.*.access_ip_v4)}:10000,password=${var.haa-password}"
</powershell>
EOF
}

### HAA ####
data "template_file" "haa-master" {
  template   = <<EOF
#!/bin/bash
yum update -y
yum install -y wget
wget http://download.uipath.com/haa/get-haa.sh
chmod +x get-haa.sh
sh get-haa.sh -u ${var.haa-user} -p ${var.haa-password} -l ${var.haa-license}
EOF
}

data "template_file" "haa-slave" {
  template   = <<EOF
#!/bin/bash
yum update -y
yum install -y wget
wget http://download.uipath.com/haa/get-haa.sh
chmod +x get-haa.sh
sh get-haa.sh -u  ${var.haa-user} -p ${var.haa-password} -j ${flexibleengine_compute_instance_v2.haa-master.access_ip_v4}
EOF 
}
