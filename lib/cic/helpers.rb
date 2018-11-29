module CIC
  module Helpers
    def cic_pwd
      Dir.pwd.gsub(ENV['CIC_MOUNT'].to_s, ENV['CIC_PWD'].to_s)
    end
  end
end
