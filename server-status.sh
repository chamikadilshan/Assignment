#!/bin/bash

now=$(date)
#nginx_status=$(systemctl status nginx | grep -w "Active: active (running)")
server_response=$(curl -I "3.80.100.122") #Get real time http response from web server

#Check whether nginx server is runinig by ssh into the server 
if ssh -i private.key ec2-user@ec2-3-80-100-122.compute-1.amazonaws.com -y systemctl status nginx | grep -w "Active: active (running)" ; then

	   echo "Nginx is up and running"; mysql -h server-public-domain --user=example --password=example serverstatus << EOF
	   INSERT INTO script_state (\`Datetime\`,\`response\`) VALUES ('$now','$server_response'); #Insert timestamp and status of the web server to the RDS mysql DB 
EOF
	   
	   
   else

	   ssh -i private.key ec2-user@ec2-3-80-100-122.compute-1.amazonaws.com -y sudo systemctl start nginx ; #If nginx server is not running then start the through SSH.
		
	   echo "Nginx server started"
fi



#check whether web server is serving the right content with correct response code
if curl -I "3.80.100.122" 2>&1 | grep -w "HTTP/1.1 200 OK" && curl  "3.80.100.122" 2>&1 | grep -w "Hello World" ; then

           echo  "$now : The web server is running and serving correct content"

    else

           echo "The web server is not running properly"

fi
