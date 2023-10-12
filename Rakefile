require 'fileutils'

INSTALL_DIR = '/usr/lib/interrubygator'
INSTALL_BIN = '/usr/bin/interrubygator'

task :install do 
  puts "!!THIS TASK NEEDS TO BE RAN AS SUDO/ADMIN!!"

  if File.directory? INSTALL_DIR
    FileUtils.rm_rf INSTALL_DIR
  end

  if File.exist?(INSTALL_BIN) || File.symlink?(INSTALL_BIN)
    File.delete INSTALL_BIN
  end

  Dir.mkdir INSTALL_DIR

  FileUtils.cp_r './.', INSTALL_DIR

  File.symlink File.expand_path(File.join('bin', 'interrubygator'), INSTALL_DIR), INSTALL_BIN
end
