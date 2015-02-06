num_workers = ENV["NUM_WORKERS"].to_i
tor_port = ENV["TOR_PORT"].to_i
tor_control_port = 50001
current_dir = File.expand_path File.dirname(__FILE__)
log_dir = "#{current_dir}/log"
FileUtils.mkdir_p log_dir


num_workers.times do |num|
  God.watch do |w|
    w.name          = "tor-#{num}"
    w.group         = 'tor'
    w.start         = "tor --SocksPort #{tor_port+num} --ControlPort #{tor_control_port+num} --CookieAuthentication 0 --HashedControlPassword \"\" --NewCircuitPeriod 60 --DataDirectory #{current_dir}/data/#{tor_port+num} --Log \"notice syslog\""
    w.log           = "#{log_dir}/tor.log"
    w.keepalive
  end
end