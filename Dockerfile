FROM centos:7

# Author
MAINTAINER ysato <yusuke.sato06@g.softbank.co.jp>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Copy Init file
COPY ./docker_config/init_container.sh /bin/
RUN chmod 755 /bin/init_container.sh

# Update
RUN yum -y update 

# Install tools
RUN yum -y install curl which perl perl-CGI

# Install apache
RUN yum -y install httpd; \
    cp /etc/mime.types /etc/httpd/conf/
COPY ./docker_config/httpd.conf /etc/httpd/conf/
COPY ./docker_config/welcome.conf /etc/httpd/conf.d/
# Setting Apache
RUN rm -rf /var/www/html; \
    ln -s /home/site/wwwroot/html /var/www/html; \
    rm -rf /var/www/cgi-bin; \
    ln -s /home/site/wwwroot/cgi-bin /var/www/cgi-bin; \
    rm -rf /var/log/httpd; \
    ln -s /home/LogFiles/httpd /var/log/httpd; \
# Setting SSH   
    rm -rf /var/log/secure; \
    ln -s /home/LogFiles/sshd /var/log/secure; \
# Setting Supervisor
    ln -s /home/LogFiles/supervisord /var/log/supervisord

# Install Python
RUN yum -y install gcc python-devel
RUN curl https://bootstrap.pypa.io/ez_setup.py -o - | python
RUN curl https://bootstrap.pypa.io/get-pip.py -o - | python
RUN pip install pip

# Install Supervisor and config
RUN pip install supervisor
RUN mkdir /etc/supervisord.d
COPY  ./docker_config/supervisord.conf /etc/supervisord.d/

# Install ssh-server
RUN yum -y install openssh-server
RUN ssh-keygen -A

# Setup for Azure Web App
RUN echo "root:Docker!" | chpasswd; \
    echo "cd /home" >> ~/.bash_profile
COPY ./docker_config/sshd_config /etc/ssh/

# Change Timezone
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

EXPOSE 2222 80
ENTRYPOINT [ "/bin/init_container.sh" ]