#!/bin/bash
yum update -y
yum install -y httpd
echo "<h1>Hello from App $(hostname)</h1>" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd
