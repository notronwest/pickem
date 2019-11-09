<VirtualHost *:80>
	ServerAdmin webadmin@inquisibee.com
	ServerName www.52andcloudy.com
	ServerAlias 52andcloudy.com
	DirectoryIndex index.php index.htm index.html
	DocumentRoot /store/apache/htdocs/52andcloudy.com
	<Directory />
		Options FollowSymLinks
		AllowOverride None		
	</Directory>

	<Directory /store/apache/htdocs/52andcloudy.com>
		RewriteEngine On
                RewriteBase /web/
                RewriteRule ^index\.php$ – [L]
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule . /web/index.php [L]
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Order allow,deny
		allow from all
	</Directory>
	
	ErrorLog ${APACHE_LOG_DIR}/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
