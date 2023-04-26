#!/bin/bash

sudo yum update -y
sudo yum install httpd -y

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF > /var/www/html/index.html
<html>
<head>
  <title>Terraform Build Info</title>
</head>
<body bgcolor="black">
  <h2><font color="gold">Build by Terraform <font color="red">v0.12</font></h2><br><p>
  <font color="green">Server Private IP: <font color="aqua">$myip<br><br>

  <font color="magenta">
  <b>Version 1.0</b>
</body>
</html>
EOF
# другой вариант изменить файл /var/www/html/index.html
echo "<html><body bgcolor=blue><center><h1><p><font color=red>Server IP address - $myip</h1></center></body></html>" | sudo tee /var/www/html

# systemctl start httpd
systemctl enable --now httpd