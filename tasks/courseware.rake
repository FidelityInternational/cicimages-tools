# rubocop:disable Metrics/BlockLength
namespace :courseware do
  require 'pty'

  def run(command)
    stdout, _stdin, _pid = PTY.spawn command
    while (string = stdout.gets)
      print string
    end
  end

  desc 'build course image'
  task :build do
    Dir.chdir("#{__dir__}/../") do
      image = File.read('.courseware-image')
      version = File.read('.courseware-version')

      run "docker build . -t #{image}:#{version}"
    end
  end

  desc 'publish course image'
  task :publish do
    image = File.read('.courseware-image')
    version = File.read('.courseware-version')

    puts 'publishing image (docker output is hidden: takes a while)'
    `docker push #{image}:#{version}`
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
# rubocop:enable Metrics/BlockLength
