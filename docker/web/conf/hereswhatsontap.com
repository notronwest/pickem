<VirtualHost *:80>
	ServerAdmin webadmin@inquisibee.com
	ServerName www.hereswhatsontap.com
	ServerAlias hereswhatsontap.com
	DirectoryIndex index.php index.htm index.html
	DocumentRoot /store/apache/htdocs/www.hereswhatsontap.com/app/public
	
	#SSLEngine on
	#SSLCertificateFile /store/apache/ssl/inquisibee.com.crt
	#SSLCertificateKeyFile /store/apache/ssl/inquisibee.key
	#SSLCertificateChainFile /store/apache/ssl/intermediate.crt

	#<IfModule mod_ssl.c>
        #   ErrorLog /var/log/apache2/ssl_engine.log
        #   LogLevel error
        #</IfModule>

	<Directory />
		Options FollowSymLinks
		AllowOverride None		
	</Directory>

	SetEnv APP_ENV prod
	SetEnv APP_DEBUG false


	<Directory /store/apache/htdocs/www.hereswhatsontap.com/app/public>
		<IfModule mod_rewrite.c>
                    Options -MultiViews
                    RewriteEngine On
                    RewriteCond %{REQUEST_FILENAME} !-f
                    RewriteRule ^(.*)$ index.php [QSA,L]
                </IfModule>		
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Order allow,deny
		allow from all
	</Directory>
	
	ErrorLog ${APACHE_LOG_DIR}/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel error

	CustomLog ${APACHE_LOG_DIR}/access.log combined

    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>

	Alias /phpmyadmin /usr/share/phpmyadmin
	<Directory /usr/share/phpmyadmin>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>


