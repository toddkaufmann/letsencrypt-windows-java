@echo off

@rem should look this up
@rem setlocal

@rem generation using instructions @
@rem https://github.com/porunov/acme_client/wiki/Get-a-certificate-for-multiple-domains

@rem letsencrypt folder
set LE=\Users\todd\LE
@rem TODO should be different for each?
@rem can you share acct_key ?


@rem set email=admin@example.com
@rem set domain=example.com

@rem static folder for tomcat
@rem set tc_static=C:\apache-tomcat-7\webapps\static
@rem  .. aka webapps\ROOT ?
@rem  .. check your server.xml file
set well_known_acme=%tc_static\.well-known\acme-challenge
@rem /var/www/.well-known/acme-challenge


set logdir=%LE%\log
set workdir=%LE%\workdir

@rem need something minimal if you only have the openssl binary
@rem TODO copy specify the path here
set openssl_cnf=openssl.cnf

@rem various outputs .. if they exist, that step is skipped

set acct_key=%LE%\01-acct.key
set dom_priv_key=%LE%\02-hh.key
@rem I skipped step 3
set dom_csr=%LE%\04-hh.csr
set registered=%LE%\05-registered.txt
set challenge=%LE%\06-challenge.txt
set verify=%LE%\07-verify.txt


@rem .. between steps:
set pause=echo ===========
@rem pause to stop between steps, make you press a key
set pause=pause


@rem 0 have jar & openssl bin
@rem java 8
@echo 00.  assuming jar and openssl are here (but I should check ..)

@rem 1 
if exist %acct_key% (
    @echo 01. got acct_key
) else (
    openssl genrsa -out %acct_key% 2048
    echo errorlevel is %errorlevel% / %ERRORLEVEL%
    %pause%
)

echo afterif: errorlevel is %errorlevel% / %ERRORLEVEL%


@rem 2 # private domain key
if exist %dom_priv_key% (
   @echo 02. got dom_priv_key
) else (
    openssl genrsa -out %dom_priv_key% 2048
    %pause%
)	    

@rem # 3 openssl.cnf config for alt names [optional]
@rem (I didn't do it)
@echo 03. skipping config for SAN

@rem # 4  csr
@rem  -config /etc/pjac/openssl.cnf
if exist %dom_csr% (
   @echo 04. got dom_csr
) else (
 @echo on
    openssl req -config %openssl_cnf%  -new -key %dom_priv_key% ^
  -sha256 -nodes -subj "/C=US/ST=Pennsylvania/L=Pittsburgh/O=HH/OU=net.dept/CN=%domain%/emailAddress=%email%" ^
  -outform PEM -out %dom_csr%
 @echo off
%pause%
)

@echo on
@echo  .. before 5 ....

@rem 5 register acct
if exist %registered% (
   @echo 05. got  registered
) else (
    java -jar acme_client.jar --log-dir %logdir% --command register -a %acct_key% ^
      --with-agreement-update --email %email% > %registered%
    echo 05- errorlevel is %errorlevel% / %ERRORLEVEL%
    type %registered%
    %pause%
)
echo 05- afterif: errorlevel is %errorlevel% / %ERRORLEVEL%

%pause%


@rem 6 get challenge / dl
@rem
@rem if multiple were speicied in 4, then could specify here; eg
@rem     -d www.example.com -d admin.example.com -d www.admin.example.com
if exist %challenge% (
   @echo 06. got challenge
) else (
    java -jar acme_client.jar --command authorize-domains -a %acct_key% ^
      -w %workdir% -d %domain% --well-known-dir %well_known_acme% ^
      --one-dir-for-well-known > %challenge%
    echo 06-  errorlevel is %errorlevel% / %ERRORLEVEL%
    type %challenge%
    %pause%
)
echo 06- afterif: errorlevel is %errorlevel% / %ERRORLEVEL%



@rem 7 verify challenge
@rem  .. likewise, can be: -d www.example.com -d admin.example.com -d www.admin.example.com

if exist %verify% (
   @echo 07. got  verified
) else (
    java -jar acme_client.jar --command verify-domains -a %acct_key% ^
      -w %workdir% -d %domain% > %verify%
    echo 07- errorlevel is %errorlevel% / %ERRORLEVEL%
    type %verify%
    %pause%
)
echo 07- afterif: errorlevel is %errorlevel% / %ERRORLEVEL%

%pause%
@rem 8 gen cert & d/l

%pause%

@rem have 3 .pem files now?

%pause%

@rem conversion time 

@rem http://robblake.net/post/18945733710/using-a-pem-private-key-and-ssl-certificate-with
@rem 1 openssl .pem -> .p12

@rem 2 import w/ keytool
@rem 3 intermediate keys?  or is fullchain good ?
@rem 4 move keystore to tomcat
@rem 5 configure tomcat
@rem 6 restart, test tomcat
