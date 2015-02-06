require 'tor'
require 'mechanize'

class Requester
  def initialize
    @agent = Mechanize.new
    @agent.set_proxy("127.0.0.1", 5566)
  end
  
  def perform
    i = 1
    loop do
      ip_address = @agent.get("http://bot.whatismyipaddress.com").content
      puts "Run request with IP : #{ip_address}"
      
      if i%10==0
        puts "Changing IP address"
        Tor::Controller.connect(:port => 50001) do |tor|
          tor.authenticate("password")
          tor.signal("newnym")
          sleep 10
        end
      end
      i+=1
    end
  end
end

threads = []
10.times do |i|
  t = Thread.new do
    Requester.new.perform
  end
  threads << t
end
threads.each {|t| t.join}

