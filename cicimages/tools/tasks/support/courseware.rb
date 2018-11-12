module Courseware
  class << self
    def tag
      image = sanitise(File.read("#{root_dir}/.courseware-image"))
      version = sanitise(File.read("#{root_dir}/.courseware-version"))
      "#{image}:#{version}"
    end

    private

    def root_dir
      "#{__dir__}/../../../../"
    end

    def sanitise(string)
      string.chomp.strip
    end
  end
end
