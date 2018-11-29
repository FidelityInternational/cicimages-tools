require 'utils/commandline'
module Commandline
  describe Command do
    describe '#run' do
      context 'fail_on_error true' do
        it 'returns the result object' do
          command = described_class.new('boom', raise_on_error: true)

          expect { command.run }.to raise_error(described_class::Error) do |exception|
            expected_return = Return.new(stdout: '', stderr: 'bash: boom: command not found', exit_code: 127)
            expect(exception.command_return).to eq(expected_return)
          end
        end
      end

      context 'dir set' do
        it 'runs the command in that directory' do
          Dir.mktmpdir do |path|
            Dir.chdir(path) do
              command = described_class.new('pwd', dir: path)
              expect(command.run).to eq(Return.new(stdout: Dir.pwd, stderr: '', exit_code: 0))
            end
          end
        end
      end

      context 'silent false' do
        include_context :command

        subject { described_class.new('echo hello', silent: false) }

        it 'prints out the output from stdout' do
          subject.run
          expect(stdout.string).to eq("hello\n")
        end
      end

      it 'returns the result object' do
        command = described_class.new('echo hello')
        result = command.run
        expect(result).to eq(Return.new(stdout: 'hello', stderr: '', exit_code: 0))
      end
    end
  end
end
