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
      page = @agent.get("http://bot.whatismyipaddress.com")
      ip_address = page.content
      puts "Run request with IP : #{ip_address}"
      
      puts "Served by : #{page.header["x-servedby"]}"
      
      if i%10==0
        puts "Changing IP address"
        control_port = page.header["x-servedby"].to_i
        Tor::Controller.connect(:port => control_port) do |tor|
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

