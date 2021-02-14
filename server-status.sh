#!/bin/bash

now=$(date)
#nginx_status=$(systemctl status nginx | grep -w "Active: active (running)")
server_response=$(curl -I "3.80.100.122")


if ssh -i private.key ec2-user@ec2-3-80-100-122.compute-1.amazonaws.com -y systemctl status nginx | grep -w "Active: active (running)" ; then

	   echo "Nginx is up and running"; mysql -h server-stat-db.cpklkizt7iu7.us-east-1.rds.amazonaws.com --user=rootadmin --password=mQx9w3gQ8sCe serverstatus << EOF
	   INSERT INTO script_state (\`Datetime\`,\`response\`) VALUES ('$now','$server_response');
EOF
	   
	   
   else

	   ssh -i private.key ec2-user@ec2-3-80-100-122.compute-1.amazonaws.com -y sudo systemctl start nginx ;
		
	   echo "Nginx server started"
fi




if curl -I "3.80.100.122" 2>&1 | grep -w "HTTP/1.1 200 OK" && curl  "3.80.100.122" 2>&1 | grep -w "Hello World" ; then

           echo  "$now : Nginx server  is up"

    else

           echo "Nginx is down"

fi
