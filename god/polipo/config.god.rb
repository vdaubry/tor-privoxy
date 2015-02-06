polipo_port=10050
tor_port=9050
current_dir = File.expand_path File.dirname(__FILE__)
log_dir = "#{current_dir}/log"
FileUtils.mkdir_p log_dir

num_workers = 2
num_workers.times do |num|
  God.watch do |w|
    w.name          = "polipo-#{num}"
    w.group         = 'polipo'
    w.start         = "polipo proxyPort=#{polipo_port+num} socksParentProxy=127.0.0.1:#{tor_port+num} socksProxyType=socks5 diskCacheRoot='' disableLocalInterface=true allowedClients=127.0.0.1 localDocumentRoot='' logSyslog=true allowedPorts='1-65535' tunnelAllowedPorts='1-65535'"
    w.log           = "#{log_dir}/polipo.log"
    w.keepalive
  end
end