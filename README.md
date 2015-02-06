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


Credits :
---------

Inspired by : 

* http://blog.databigbang.com/running-your-own-anonymous-rotating-proxies/
* https://github.com/mattes/rotating-proxy