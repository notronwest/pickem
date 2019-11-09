FROM php:7.0-apache

# Move in the apache config file
COPY *.conf /etc/apache2/sites-available/

RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load
RUN ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/proxy_ajp.load
#COPY mods/rewrite.load /etc/apache2/mods-enabled/


# enable SSL
# enable AJP
# enable PROXY
