#!/bin/bash
yum update -y
yum install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb
