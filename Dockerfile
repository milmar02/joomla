FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y wget apache2 nano unzip libapache2-mod-php7.4 openssl php-imagick php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-pgsql php-ssh2 php7.4-sqlite3 php7.4-xml php7.4-zip

#HTTPD
#RUN apt-get install -y libcap-dev

RUN wget https://downloads.joomla.org/cms/joomla3/3-9-26/Joomla_3-9-26-Stable-Full_Package.zip

RUN mkdir /var/www/html/joomla
RUN unzip Joomla_3-9-26-Stable-Full_Package.zip -d /var/www/html/joomla

RUN chown -R www-data:www-data /var/www/html/joomla
RUN chmod -R 755 /var/www/html/joomla

COPY joomla.conf /etc/apache2/sites-available/joomla.conf
COPY entrypoint.sh /entrypoint.sh
COPY ports.conf /etc/apache2/ports.conf

#HTTPD
#COPY httpd-foreground /usr/local/bin/httpd-foreground
#COPY httpd.conf /etc/apache2/httpd.conf
#RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/httpd
RUN mkdir /etc/apache2/vhost.d /config

RUN chgrp -R 0 /var/www/html/joomla/ && \
    chmod -R g+rwX /var/www/html/joomla/
RUN chgrp -R 0 /etc/apache2/ && \
	chmod -R g+rwX /etc/apache2/
RUN chgrp -R 0 /entrypoint.sh && \
	chmod -R g+rwX /entrypoint.sh
RUN chgrp -R 0 /var/log/ && \
	chmod -R g+rwX /var/log/
	
#HTTPD
#RUN chgrp -R 0 /etc/apache2/vhost.d /config/ /usr/local/bin/httpd-foreground && \
#	chmod -R g+rwX /etc/apache2/vhost.d /config/ /usr/local/bin/httpd-foreground
	
RUN a2enmod lbmethod_byrequests

#APACHE2
EXPOSE 8080
CMD apachectl -DFOREGROUND "$@"

#HTTPD
#STOPSIGNAL WINCH

#CMD ["/usr/local/bin/httpd-foreground"]
