module CIC
  module Helpers
    def courseware_environment
      "CIC_PWD=#{cic_pwd}"
    end

    def cic_pwd
      Dir.pwd.gsub(ENV['CIC_MOUNT'].to_s, ENV['CIC_PWD'].to_s)
    end
  end
end
