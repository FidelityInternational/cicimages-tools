module CIC
  module Helpers
    def courseware_environment
      "CIC_COURSEWARE_VERSION=#{courseware_version} CIC_COURSEWARE_IMAGE=#{courseware_image} CIC_PWD=#{cic_pwd}"
    end

    def courseware_image
      ENV['CIC_COURSEWARE_IMAGE']
    end

    def courseware_version
      ENV['CIC_COURSEWARE_VERSION']
    end

    def cic_pwd
      Dir.pwd.gsub(ENV['CIC_MOUNT'].to_s, ENV['CIC_PWD'].to_s)
    end
  end
end
