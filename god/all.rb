require 'fileutils'

ENV["NUM_WORKERS"] = ARGV[0] || "2"
ENV["TOR_PORT"] = "9050"
ENV["PROXY_PORT"] = "8118"

current_dir = File.expand_path File.dirname(__FILE__)
God.pid_file_directory ="#{current_dir}/pids"

God.load "#{current_dir}/tor/config.god.rb"
God.load "#{current_dir}/privoxy/config.god.rb"
God.load "#{current_dir}/haproxy/config.god.rb"