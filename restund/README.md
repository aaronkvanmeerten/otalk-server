On a fresh ubuntu machine, it might be necessary to install build-essential first.

* Install [libre](http://creytiv.com/re.html) by following the instructions.
  * you might want to change the prefix so it installs to /usr instead of /usr/local
* Fetch [restund](http://creytiv.com/restund.html) and unpack it
* apply the accompanying restund-auth.patch 
  * patch -p1 < restund/restund-auth.patch
* make, sudo make install
  * possibly changing the prefix again
* adapt the accomapanying restund.conf to your needs 
  * replace ip addresses
  * change the realm to match your xmpp server domain (optional)
  * and make sure it contains the same shared secret as your prosody.cfg.lua
  * copy to /etc
* copy restunds etc/restund to /etc/init.d/
* start restund, add to automatic startup process if desired
