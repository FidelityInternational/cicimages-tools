require_relative 'support/courseware'
namespace :courseware do
  require 'pty'

  def run_and_stream(command)
    stdout, _stdin, _pid = PTY.spawn command
    while (string = stdout.gets)
      print string
    end
  end

  desc 'build course image'
  task :build do
    run_and_stream "docker build . -t #{Courseware.tag}"
  end

  desc 'publish course image'
  task :publish do
    puts 'publishing image (docker output is hidden: takes a while)'
    `docker push #{Courseware.tag}`
  end

  require 'bump'
  class CoursewareVersionBumper < Bump::Bump
    def self.current_info
      version_file = "#{__dir__}/../.courseware-version"
      [File.read(version_file), version_file]
    end
  end

  namespace :bump do
    %i[patch minor major].each do |bump_type|
      desc "Bump #{bump_type} number"
      task bump_type do
        CoursewareVersionBumper.run(bump_type.to_s, commit: false)
      end
    end
  end
end
