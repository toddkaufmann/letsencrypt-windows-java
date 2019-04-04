@rem PATH should have:  java 8, openssl, jar

@rem They don't necessarily need to be in the global system environment

@rem sample settings:
set SSLDIR=D:\ssl-support
set PATH=%SSLDIR%\openssl-1.1.0h;%SSLDIR%\jre1.8.0_172\bin;%PATH%
set JRE_HOME=%SSLDIR%\jre1.8.0_172

@rem where all the work takes place:
@rem  easier (necessary?) if everything is in same drive-letter
@rem  (and be sure to call from there)
set LE=D:%SSLDIR%\letsencrypt

@rem Configure variables here,
@rem then call main script


@rem ROOT of all your stuff;

@rem letsencrypt folder
@rem set LE=\Users\todd\LE  -- see above
@rem it should exist

@rem also:  logdir workdir certdir
set logdir=%LE%\log

@rem TODO folder should be different for each? .. is easiest.

@rem Required:
set email=admin@example.com
@rem Required:  your domain to get cert form
set domain=example.com

@rem CN: CommonName - your domain
@rem OU: OrganizationalUnit
@rem O: Organization
@rem L: Locality (City, usually)
@rem ST: StateOrProvinceName
@rem C: CountryName
set SUBJECT="/C=US/ST=Pennsylvania/L=Pittsburgh/O=Company Ltd.,/OU=web marketing/CN=%domain%/emailAddress=%email%" 

@rem req:   a folder that can serve static files
@rem ROOT is maybe okay too
@rem tomcat9 has been tested and works too.
set tc_static=D:\apache-tomcat-7.0.81\webapps\static

@rem It will need to be able to serve up static files for challenge from:
@rem set well_known_acme=%tc_static\.well-known\acme-challenge

call pjac-gen.bat
