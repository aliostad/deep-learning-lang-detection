require 'ChildProcess'
require 'Tempfile' 
require 'pry'

process = ChildProcess.build("ruby", "-e", "sleep")

process = ChildProcess.build("cmd")#, "-e", "sleep")

# inherit stdout/stderr from parent...
process.io.inherit!

# ...or pass an IO
#process.io.stdout = Tempfile.new("child-output")

        stdout, stdout_writer = IO.pipe
        stderr, stderr_writer = IO.pipe
        process.io.stdout = stdout_writer
        process.io.stderr = stderr_writer

 
#process.io.stdin ; 
process.duplex = true
# process.io.stdin.sync = true
# modify the environment for the child
process.environment["a"] = "b"
process.environment["c"] = nil

# start the process
process.start
puts 'what'
# check process status
process.alive?    #=> true
process.exited?   #=> false

# wait indefinitely for process to exit...
#process.wait
process.exited?   #=> true
puts 'done'
binding.pry

# ...or poll for exit + force quit
begin
  process.poll_for_exit(10)
rescue ChildProcess::TimeoutError
  process.stop # tries increasingly harsher methods to kill the process.
end