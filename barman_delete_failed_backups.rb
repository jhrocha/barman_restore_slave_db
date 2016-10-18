require 'open3'
cmd= 'barman list-backup main-trakto-db'

Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
  backup_list= stdout.read.split("\n")
        backup_list.each do |backup_data|
          if backup_data.include? "FAILED"
           cmd_delete= "barman delete main-trakto-db #{backup_data.split[1]}"
           Open3.popen3(cmd_delete) do |stdin, stdout, stderr, wait_thr|
            puts "Backup #{backup_data.split[1]} from main-trakto-db deleted"
           end
          end
        end
end
