require 'erb'
num_workers = ENV["NUM_WORKERS"].to_i
tor_port = ENV["TOR_PORT"].to_i
proxy_port=ENV["PROXY_PORT"].to_i

current_dir = File.expand_path File.dirname(__FILE__)
log_dir = "#{current_dir}/log"
FileUtils.mkdir_p log_dir

config_erb_path = "#{current_dir}/config/privoxy.erb"
num_workers.times.each do |num|
  @privoxy_port=proxy_port+num
  @tor_port=tor_port+num
  
  erb = ERB.new(File.read(config_erb_path))
  IO.write("#{current_dir}/config/privoxy-#{num}", erb.result(binding))
end

num_workers.times do |num|
  God.watch do |w|
    w.name          = "privoxy-#{num}"
    w.group         = 'privoxy'
    w.start         = "privoxy --no-daemon #{current_dir}/config/privoxy-#{num}"
    w.log           = "#{log_dir}/privoxy.log"
    w.keepalive
  end
end