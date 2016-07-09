require 'open3'
cmd = 'barman list-backup YOUR_DB_IDENTIFIER'

Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
  backup_list= stdout.read

  latestVersionID= backup_list.split[1]
  
  # The path to the postgres may be different. In my case, is below
  cmd= "barman recover --remote-ssh-command 'ssh your_user@host' YOUR_DB_IDENTIFIER /var/lib/postgresql/9.3/main/"

  if  backup_list.split("\n").first.include? "FAILED"
   Open3.popen3("echo 'Could not restore the slave database'")
  else
   Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
    puts "[RESTORE DATABASE] Restoring slave database from backup #{latestVersionID}"
    puts "stout: #{stdout.read}"
    puts "sterr: #{stderr.read}"
   end
  end
