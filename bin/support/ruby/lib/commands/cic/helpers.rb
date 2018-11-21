module Commands
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
        ENV['CIC_PWD']
      end
    end
  end
end
