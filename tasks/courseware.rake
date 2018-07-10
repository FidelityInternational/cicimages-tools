namespace :courseware do
  require 'pty'
  task :build do
    image = File.read("#{__dir__}/.courseware-image")
    version = File.read("#{__dir__}/.courseware-version")

    stdout, _stdin, _pid = PTY.spawn "docker build #{__dir__} -t #{image}:#{version}"
    while (string = stdout.gets)
      puts string
    end
  end

  require 'bump'
  class CoursewareVersionBumper < Bump::Bump
    def self.current_info
      [File.read('/Users/leon/Projects/ci_training/.courseware-version'),
       '/Users/leon/Projects/ci_training/.courseware-version']
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
