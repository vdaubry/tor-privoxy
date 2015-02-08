num_workers = ENV["NUM_WORKERS"].to_i
tor_port = ENV["TOR_PORT"].to_i
tor_control_port = ENV["TOR_CONTROL_PORT"].to_i
current_dir = File.expand_path File.dirname(__FILE__)
log_dir = "#{current_dir}/log"
FileUtils.mkdir_p log_dir


num_workers.times do |num|
  God.watch do |w|
    w.name          = "tor-#{num}"
    w.group         = 'tor'
    w.start         = "tor --SocksPort #{tor_port+num} --ControlPort #{tor_control_port+num} --CookieAuthentication 0 --HashedControlPassword \"16:3E49D6163CCA95F2605B339E07F753C8F567DE4200E33FDF4CC6B84E44\" --NewCircuitPeriod 60 --DataDirectory #{current_dir}/data/#{tor_port+num} --Log \"notice syslog\""
    w.log           = "#{log_dir}/tor.log"
    w.keepalive
  end
end