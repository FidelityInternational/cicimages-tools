require 'colorize'
require 'open3'
require_relative 'commandline/return'
require_relative 'commandline/output'

module Commandline
  def run(command)
    stdout, stderr, status = Open3.capture3("bash -c '#{command}'")
    Return.new(stdout: stdout, stderr: stderr, exit_code: status.exitstatus)
  end
end
