FROM php:7.0-apache

# Move in the apache config file
COPY 000-default.conf /etc/apache2/sites-available/
COPY rewrite.load /etc/apache2/mods-enabled/
