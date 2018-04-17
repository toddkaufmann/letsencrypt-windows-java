
== Windows bat script to automate letsencrypt


=== Files here:

* register-example.bat  -- the file you configure with your domain, environment etc.
* pjac-gen.bat          -- generate certs
* certs-to-jks.bat      -- convert 


=== Requirements:

 - acme_client.jar (aka 'pjac')
 - jre 8 (whatever pjac needs)
 - openssl binary

JRE 8 (or later) .. it is sufficient to download & extra the .tar.gz file
and then add bin to your path, if you already have [a different] java set up for tomcat.

'pjac' ==
Porunov Java ACME Client application (https://github.com/porunov/acme_client)
(it is sufficient to download the .jar file)


Signed OpenSSL binaries at
https://www.magsys.co.uk/delphi/magics.asp
(or pick another from https://wiki.openssl.org/index.php/Binaries, or build your own).

=== Instructions

This follows the directions at 
https://github.com/porunov/acme_client/wiki/Get-a-certificate-for-multiple-domains
except we're really only doing one

Assumes you don't have https: set up for tomcat
(so no existing keystore etc).

We'll download signed certificates from Let's Encrypt as .pem files.

Convert to pkcs12 (aka .p12) and use that directly

Steps:

Download this directory

Make a copy of this script, and configure for your domain/email/etc.

    copy register-example-com.bat register-MY-DOMAIN.bat

You can have multiple.
Currently best to have separate LetsEncrypt folders for each.

modify to your values

execute it, it will call main script

== Use with tomcat

This uses HTTP01 challenge; ie, it puts some files
in .well-known/acme-challenge directory
and then LE expects to find them there

1. set tc_static to 'docroot' folder
    (actually can be any server, doesn't need to be tomcat)
2. well_known_acme is probably ok..

== troubleshooting

=== General:

probably turn echo on
set pause=pause (if its not)


=== messages:

    2018-04-17 03:09:21 ERROR com.jblur.acme_client.Parameters:281 - Your authorization uri list file doesn't exists. Seems that it is either wrong working directory or you haven't authorized your domains yet: \Users\todd\LE\workdir\authorization_uri_list

check & make sure dir exists !


increase loglevel


