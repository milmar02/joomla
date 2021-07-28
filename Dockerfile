FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y apache2 unzip libapache2-mod-php7.4 openssl php-imagick php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-pgsql php-ssh2 php7.4-sqlite3 php7.4-xml php7.4-zip

RUN wget https://downloads.joomla.org/cms/joomla3/3-9-26/Joomla_3-9-26-Stable-Full_Package.zip

RUN mkdir /var/www/html/joomla
RUN unzip Joomla_3-9-26-Stable-Full_Package.zip -d /var/www/html/joomla

RUN chown -R www-data:www-data /var/www/html/joomla
RUN chmod -R 755 /var/www/html/joomla

COPY joomla.conf /etc/apache2/sites-available/joomla.conf
COPY entrypoint.sh /entrypoint.sh

RUN chgrp -R 0 /var/www/html/joomla/ && \
    chmod -R g+rwX /var/www/html/joomla/
RUN chgrp -R 0 /etc/apache2/ && \
	chmod -R g+rwX /etc/apache2/
RUN chgrp -R 0 /entrypoint.sh && \
	chmod -R g+rwX /entrypoint.sh


EXPOSE 80
CMD apachectl -D FOREGROUND

