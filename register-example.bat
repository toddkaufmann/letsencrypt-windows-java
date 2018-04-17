
@rem Configure variables here,
@rem then call main script


@rem ROOT of all your stuff;

@rem letsencrypt folder
set LE=\Users\todd\LE
@rem it should exist

@rem also:  logdir workdir certdir
set logdir=%LE%\log

@rem TODO folder should be different for each? .. is easiest.
@rem can you share acct_key ?

@rem req:
set email=admin@example.com
@rem req:  your domain to get cert form
set domain=example.com

@rem CN: CommonName - your domain
@rem OU: OrganizationalUnit
@rem O: Organization
@rem L: Locality (City, usually)
@rem ST: StateOrProvinceName
@rem C: CountryName
set SUBJECT="/C=US/ST=Pennsylvania/L=Pittsburgh/O=Company Ltd.,/OU=web marketing/CN=%domain%/emailAddress=%email%" 

@rem req:   a folder that can serve static files
@rem 
set tc_static=C:\apache-tomcat-7.0.81\webapps\static

@rem It will need to be able to serve up static files for challenge from:
@rem set well_known_acme=%tc_static\.well-known\acme-challenge

call pjac-gen.bat
