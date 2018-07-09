require_relative 'output/ansible'
require_relative 'output/pytest'
require_relative 'output/cic'
module Exercise
  class Output < String

    def initialize string
      string = string.scrub
      bytes = string.bytes.delete_if { |byte| byte == 27 }
      string = bytes.pack('U*')
      super normalise(string.chomp)
    end

    def to_ansible_output
      Ansible.new(self)
    end

    def to_cic_output
      CIC.new(self)
    end

    def to_pytest_output
      Pytest.new(self)
    end

    private
    def normalise(string)
      string.gsub(/\[[\d;]+m/, '')
    end
  end
end