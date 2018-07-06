require 'utils/commandline'

describe Commandline do
  subject { Object.new.tap { |o| o.extend(described_class) } }
  describe '#run' do
    it 'gives the return' do
      output = subject.run('garbage')
      expect(output).to eq(described_class::Return.new(stdout: '',
                                                       stderr: 'bash: garbage: command not found',
                                                       exit_code: 127))
    end
  end
end
