#!/bin/bash
cat >/etc/motd <<EOL 
  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
A P P   S E R V I C E   O N   L I N U X
Documentation: http://aka.ms/webapp-linux
PHP quickstart: https://aka.ms/php-qs
EOL
cat /etc/motd

# Get environment variables to show up in SSH session
eval $(printenv | awk -F= '{print "export " $1"="$2 }' >> /etc/profile)

mkdir /home/site/wwwroot/html
touch /home/site/wwwroot/html/index.html && echo "Hello World!" >> /home/site/wwwroot/html/index.html
mkdir /home/site/wwwroot/cgi-bin
mkdir /home/LogFiles/httpd
mkdir /home/LogFiles/secure
mkdir /home/LogFiles/supervisord

/usr/bin/supervisord -c /etc/supervisord.d/supervisord.conf