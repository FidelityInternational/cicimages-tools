module Courseware
  class << self
    attr_reader :version_file, :repository

    def init(version_file:, repository:)
      @repository = repository
      @version_file = version_file
    end

    def tag
      "#{repository}:#{version}"
    end

    def version
      sanitise(File.read(version_file))
    end

    private

    def sanitise(string)
      string.chomp.strip
    end
  end
end
