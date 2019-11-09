<VirtualHost *:80>
	ServerAdmin dilemo@gmail.com
	ServerName www.notronwest.com
	DirectoryIndex index.php index.cfm index.htm index.html
	DocumentRoot /store/apache/htdocs/notronwest.com
	<Directory />
		Options FollowSymLinks
		AllowOverride None		
	</Directory>

	<Directory /store/apache/htdocs/notronwest.com>
		RewriteEngine On
                RewriteBase /blog/
                RewriteRule ^index\.php$ – [L]
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule . /blog/index.php [L]
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Order allow,deny
		allow from all
	</Directory>

	ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
	<Directory "/usr/lib/cgi-bin">
		AllowOverride None
		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
		Order allow,deny
		Allow from all
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog ${APACHE_LOG_DIR}/access.log combined

    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>

</VirtualHost>

<VirtualHost *:80>
        ServerAdmin dilemo@gmail.com
        ServerName eliminator.notronwest.com
        DirectoryIndex index.cfm index.php index.htm index.html
        DocumentRoot /store/apache/htdocs/notronwest.com/eliminator
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>

        <Directory /store/apache/htdocs/notronwest.com/eliminator>
                RewriteEngine On
                RewriteBase /blog/
                RewriteRule ^index\.php$ – [L]
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule . /blog/index.php [L]
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>

        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn

        CustomLog ${APACHE_LOG_DIR}/access.log combined

    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>

</VirtualHost>
