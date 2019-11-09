FROM php:7.0-apache


# Delete default config
RUN rm /etc/apache2/sites-available/000-default.conf
# Move in the apache config file
COPY *.conf /etc/apache2/sites-enabled/

RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load
RUN ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/proxy_ajp.load
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load

# COPY ssl certificates
RUN mkdir /var/www/ssl
COPY ssl/* /var/www/ssl/

# Make sure permissions are correct
RUN chmod -R 700 /var/www/ssl && \
    chmod -R 600 /var/www/ssl/* && \
    chown -R root:root /var/www/ssl

# enable SSL
# enable AJP
# enable PROXY
