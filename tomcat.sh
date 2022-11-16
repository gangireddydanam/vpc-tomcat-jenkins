#!/bin/bash 
sudo yum update -y 
sudo amazon-linux-extras install java-openjdk11 -y
cd /opt
wget -O /opt/apache-tomcat-9.0.65-windows-x64.zip https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65-windows-x64.zip 
unzip apache-tomcat-9.0.65-windows-x64.zip
mv apache-tomcat-9.0.65 tomcat9
rm -f apache-tomcat-9.0.65-windows-x64.zip
