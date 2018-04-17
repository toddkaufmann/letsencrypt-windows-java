@echo off
setlocal

@rem CONFIG  .. redundant with your register-<domain>.bat script
@rem  our root:
set LE=\Users\todd\LE

@rem export password
set EXP_PW=todaysExport417

@rem contains 3 .pem files:  cert, chain, fullchain
set cert_dir=%LE%\certdir


@rem http://robblake.net/post/18945733710/using-a-pem-private-key-and-ssl-certificate-with
@rem 1 openssl .pem -> .p12

@rem openssl pkcs12 -export -in <your_CA_signed_PEM_cert> -inkey <your_PEM_private.key> ^
@rem     -out <your_certificate_name>.p12 -name tomcat -chain -CAFile <your_root_CA_certificate>

@rem .. this cmd from
@rem https://community.letsencrypt.org/t/how-to-use-the-certificate-for-tomcat/3677/2
@rem openssl pkcs12 -export -in cert.pem -inkey privkey.pem -out cert_and_key.p12 -name tomcat -CAfile chain.pem -caname root

@rem .. or this:
@rem openssl pkcs12 -export -in $certdir/fullchain.pem -inkey $certdir/privkey.pem -out $certdir/cert_and_key.p12 -name tomcat -CAfile $certdir/chain.pem -caname root -password pass:aaa

@rem DEBUG @echo on

if exist %cert_dir%\cert-and-key.p12 (
   @echo already have cert-and-key.p12
) else (
  openssl pkcs12 -export  -in %cert_dir%\fullchain.pem -inkey %dom_priv_key% ^
                         -out %cert_dir%\cert-and-key.p12 ^
           -name tomcat -CAfile %cert_dir%\chain.pem -caname root ^
	   -password pass:%EXP_PW%
@rem need a password for export or you will be prompted
    echo 1. errorlevel is %errorlevel%
    %pause%
)

exit /b %errorlevel%

@rem this failed -- args don't look right (eg '-chain' ?)
if exist %cert_dir%\cert.p12 (
    @echo Converted to .p12 already
) else (
    openssl pkcs12 -export -in %cert_dir%\cert.pem -inkey %dom_priv_key% ^
                      -out %cert_dir%\cert.p12 ^
		      -name tomcat -chain -CAFile %cert_dir%\fullchain.pem
    echo 1. errorlevel is %errorlevel%g
    %pause%
)

exit /b %errorlevel%

pause

@rem 2 import w/ keytool

keytool -importkeystore -deststorepass <a_password_for_your_java_keystore> -destkeypass <a_password_for_the_key_in_the_keystore>-destkeystore tomcat.keystore -srckeystore <exported_private_key_and_cert.p12> -srcstoretype PKCS12 -srcstorepass <the_password_I_told_you_to_remember> -alias tomcat


@rem 3 intermediate keys?  or is fullchain good ?

keytool -import -alias cross -keystore tomcat.keystore -trustcacerts -file gd_cross_intermediate.crt
keytool -import -alias intermed -keystore tomcat.keystore -trustcacerts -file gd_intermediate.crt

@rem 4 move keystore to tomcat
@rem  .. copy somewhere, maybe in to conf/ 

@rem 5 configure tomcat

<Connector port="8443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true" keystoreFile="path_to_your_keystore_file" keystorePass="the_password_you_created_for_your_keystore" clientAuth="false" sslProtocol="TLS"/>

@rem 6 restart, test tomcat
