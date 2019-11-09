FROM php:7.0-apache

# Move in the apache config file
COPY *.conf /etc/apache2/sites-available/

RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load
RUN ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/proxy_ajp.load
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load

# COPY ssl certificates
RUN mkdir /var/www/ssl
COPY ssl/* /var/www/ssl

# Make sure permissions are correct
RUN chmod -r 700 /var/www/ssl && /
    chmod -r 600 /var/www/ssl/* && /
    chown -r root:root /var/www/ssl

# enable SSL
# enable AJP
# enable PROXY
