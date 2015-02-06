Multiple rotating Tor proxy
===========================

__Goal__ : Use lots of different IP addresses for multi-threaded Mechanize requests.

__How it works__ : A God script to launch many instances of Tor. Run a privoxy instance for each Tor instance to translate HTTP proxy to SOCKS proxy. HAproxy is used to distribute requests in a round-robin fashion


```
                        <-> Privoxy 1 <-> Tor proxy 1
Client <---->  HAproxy  <-> Privoxy 2 <-> Tor proxy 2
                        <-> Privoxy n <-> Tor proxy n
```


Demo
----

![](https://github.com/vdaubry/tor-privoxy/blob/master/terminal.gif)


Usage
-----

Install Tor, Privoxy, HAProxy:

    apt-get install tor privoxy haproxy

To run multiple Tor circuits :

```bash
# Run 10 Tor circuit
god -c god/all.rb 10
```

Get a different IP for each Mechanize request :

```ruby
agent = Mechanize.new
agent.set_proxy("127.0.0.1", 5566)
puts agent.get("http://bot.whatismyipaddress.com").content
```

Changing circuit
----------------

Each Tor instance is set to build a new circuit (new IP) every 60sec, see : https://www.torproject.org/docs/tor-manual.html.en#NewCircuitPeriod

You can force a Tor instance to build a new circuit using the [Tor gem](https://github.com/bendiken/tor-ruby)
Carefull : the ```signal``` method to send a ```newnym``` to Tor is only available on the master branch (06/02/2015)


ex:

```ruby
  Tor::Controller.connect(:port => 50001) do |tor|
    tor.authenticate
    tor.signal("newnym")
    sleep 10
  end
```

We sleep 10sec because Tor delays newnym signal : https://trac.torproject.org/projects/tor/ticket/394
In the Tor logs the delay seems random between 1 and 10sec


Hashed control password :
-------------------------

    > Tor will accept connections on this port and allow those connections to control the Tor process using the 
    > Tor Control Protocol (described in control-spec.txt). Note: unless you also specify one or more of 
    > HashedControlPassword or CookieAuthentication, setting this option will cause Tor to allow any process on 
    > the local host to control it.
    
If you specify a ControlPort without a HashedControlPassword or CookieAuthentication you'll get a warning in the logs (well deserved ;)

In order to specify a control password, generate a hash with :

```tor --hash-password password```

Use the hash when starting Tor : 

```--HashedControlPassword \"16:3E49D6163CCA95F2605B339E07F753C8F567DE4200E33FDF4CC6B84E44\"```

And when authenticating use your password :

```ruby
Tor::Controller.connect(:port => 50001) do |tor|
  tor.authenticate("password")
end
```


Credits :
---------

Inspired by : 

* http://blog.databigbang.com/running-your-own-anonymous-rotating-proxies/
* https://github.com/mattes/rotating-proxy