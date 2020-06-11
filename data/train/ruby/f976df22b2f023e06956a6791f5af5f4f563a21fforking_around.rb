puts "Parent process pid (before fork) is #{Process.pid}.\n"

if fork
  current_process = Process.pid
  parent_process = Process.ppid
  printf "Entered the *if* block during Process #{current_process}."
  printf "\nThe parent of this process is #{Process.ppid}, which should be bash.\n\n"
else
  current_process = Process.pid
  parent_process = Process.ppid
  printf "Entered the *else* block during Process #{current_process}."
  printf "\nThe parent of this process is #{parent_process}, which should be the original of this process.\n\n"
end

