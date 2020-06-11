##########################################################################
# test_create.rb
#
# Simple test program for the Process.create() method.
##########################################################################
Dir.chdir('..') if File.basename(Dir.pwd) == 'examples'
$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift Dir.pwd + '/lib'
Dir.chdir('examples') rescue nil

require "win32/process"

p Process::WIN32_PROCESS_VERSION

struct = Process.create(
   :app_name         => "notepad.exe",
   :creation_flags   => Process::DETACHED_PROCESS,
   :process_inherit  => false,
   :thread_inherit   => true,
   :cwd              => "C:\\",
   :inherit          => true,
   :environment      => "SYSTEMROOT=#{ENV['SYSTEMROOT']};PATH=C:\\"
)

p struct

=begin
# Don't run this from an existing terminal
pid = Process.create(
   :app_name       => "cmd.exe",
   :creation_flags => Process::DETACHED_PROCESS,
   :startf_flags   => Process::USEPOSITION,
   :x              => 0,
   :y              => 0,
   :title          => "Hi Dan"
)

puts "Pid of new process: #{pid}"
=end
