$LOAD_PATH.unshift("#{__dir__}/../bin/support/ruby/lib")
require_relative '../support/courseware'
require 'utils/commandline'
namespace :courseware do
  include Commandline

  desc 'build course image'
  task :build do
    run "docker build . -t #{Courseware.tag}", silent: false
  end

  desc 'publish course image'
  task :publish do
    run "docker push #{Courseware.tag}"
  end

  require 'bump'
  class CoursewareVersionBumper < Bump::Bump
    def self.current_info
      [Courseware.version, Courseware.version_file]
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
