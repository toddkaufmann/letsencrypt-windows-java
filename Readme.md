
## Windows bat script to automate letsencrypt

Because it is harder than necessary for Windows,
I wrote a script to hopefully make it easier.

### Files here:

* register-example.bat  -- the file you copy and configure with your domain, environment etc.
* pjac-gen.bat          -- generate certs
* certs-to-p12.bat      -- convert .pem to .p12 keystore, usable by tomcat
* Readme.md             -- this Readme file, may contain errors.

### Requirements:

 - acme_client.jar (aka 'pjac')
 - jre 8 (whatever pjac needs)
 - openssl binary

JRE 8 (or later) .. it is sufficient to download & extra the .tar.gz file
and then add bin to your path, if you already have [a different] java set up for tomcat.

'pjac' == Porunov Java ACME Client application (https://github.com/porunov/acme_client)
(it is sufficient to download the .jar file)

Signed OpenSSL binaries for Windows are at
https://www.magsys.co.uk/delphi/magics.asp
(or pick another from https://wiki.openssl.org/index.php/Binaries, or build your own).

### Instructions

#### Overview
0.  Prep:  have requirements, edit config, make folders
1.  Run register-mydomain.bat
2.  Convert certs-to-p12
3.  Edit your server config (or whatever) to be https: enabled
4.  Test it
5.  Renew as necessary, every 2-3 months.

#### 0.  Prep

    copy register-example.bat register-mydomain.bat

Edit with your settings.

Create the `%LE%` folder, as well as
workdir certdir log
folders underneath

You you have a server that can serve up static files;
example for tomcat, in server.xml file:

    <Context docBase="C:\apache\tomcat-7.0.81\webapps\static" path="" reloadable="false"/>

If you change that, restart tomcat.

Then under this, `mkdir .well-known\acme-challenge`.

I think it needs to be on port 80.

#### 1.  run register-mydomain.bat

After you configured `register-mydomain.bat` (or whatever you called it)
with proper settings,
run it.  If it fails at any point, you should be able to delete 

This follows the directions at 
https://github.com/porunov/acme_client/wiki/Get-a-certificate-for-multiple-domains
(except we're really only doing one domain, but you could edit it).

Actually, I tried once with two names--domain and www.domain--but it didn't work.. but I probably missed something.  The file openssl.cnf.multi-altnames was used
(copy to openssl.cnf and edit the names, if you decide to try).

#### 2.  Convert certs-to-p12

    copy certs-to-p12.bat certs-to-p12-mydomain.bat

Edit like the other script.

The  signed certificates should be downloaded now from Let's Encrypt as .pem files,
in your `%LE%\certdir`.

Run this script, and if it goes well you should then have
`%cert_dir%\cert-and-key.p12`
If this file exists, the script will do nothing
(delete if you want to re-create).

#### 3.  Edit your server config

Here, we'll do tomcat.

Assumes you don't have https: already set up for tomcat
(so no existing keystore to worry about etc).

There will be an SSL connector in your `server.xml` file commented out;

    <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS"
	       keystoreFile="conf/cert-and-key.p12"
	       keystoreType="pkcs12"
	       keystorePass="todaysExport417"
	       />

Copy the created `cert-and-key.p12` file to Tomcat's `conf` folder, or change path above accordingly;
port as well.

Replace Pass here with what you set `EXP_PW` to in your script.

Stop and restart server, look for errors.

##### Force all http: to redirect to https:

A little snippet to add to your web.xml;
See e.g. https://gist.github.com/jtgasper3/10501274

(will that cause issues with .well-known ?)


#### 4.  Test it

Use your browser; many browser, multiple devices..

The online test at https://www.ssllabs.com/ is good.

#### 5.  Renew as necessary

LetsEncrypt certificates are only good for 90 days, so you'll need to renew.

Luckily, that part should be fairly easy now
(instructions to come).


## troubleshooting

### General:

probably turn echo on at appropriate place(s) in the script.

set pause=pause (if its not)

increase loglevel, check the log file.  Not all steps have it yet (I didn't need it).

Messages like

    2018-04-17 03:09:21 ERROR com.jblur.acme_client.Parameters:281 - Your authorization uri list file doesn't exists. Seems that it is either wrong working directory or you haven't authorized your domains yet: \Users\todd\LE\workdir\authorization_uri_list

Are probably right; check & make sure dir exists !

## Contribute!

Let me know if this script works for you.
If not, checkout the community at 
https://community.letsencrypt.org/

I don't normally use Windows, so my bat script writing is not good.

One step has actual error handling (or detection).

It would be nice if it were as nice as certbot on Linux
(prompt for values, save them, etc.).

Still, it's not too painful.
