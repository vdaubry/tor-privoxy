require 'mechanize'

agent = Mechanize.new
agent.set_proxy("127.0.0.1", 10051)
agent.get("http://bot.whatismyipaddress.com").content

#require 'tor'

# Tor::Controller.connect(:port => 9050) do |tor|
#   tor.authenticate
#   tor.signal("newnym")
# end