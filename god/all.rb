require 'fileutils'

current_dir = File.expand_path File.dirname(__FILE__)
God.pid_file_directory ="#{current_dir}/pids"

God.load "#{current_dir}/tor/config.god.rb"
God.load "#{current_dir}/privoxy/config.god.rb"
God.load "#{current_dir}/haproxy/config.god.rb"