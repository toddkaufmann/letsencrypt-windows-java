@echo off
setlocal

@rem CONFIG  .. redundant with your register-<domain>.bat script
@rem  our root:
set LE=\Users\todd\LE

@rem export password
set EXP_PW=todaysExport417

@rem contains 3 .pem files:  cert, chain, fullchain
@rem You don't need to change this
set cert_dir=%LE%\certdir

@rem more notes here:

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

@rem there were more steps here for creating and importing into jks,
@rem see an old revision, or one of the many posts describing it.

@rem I think just using .p12 is easier.
