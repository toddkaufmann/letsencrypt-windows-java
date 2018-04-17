
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

@rem req:   a folder that can serve static files
set tc_static=C:\apache-tomcat-7.0.81\webapps\static

set well_known_acme=%tc_static\.well-known\acme-challenge

call pjac-gen.bat
