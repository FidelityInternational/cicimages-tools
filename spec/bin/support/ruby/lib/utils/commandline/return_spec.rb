module Commandline
  describe Return do

    described_class.class_eval do
      def ==(other)
        other.stdout == stdout &&
            other.stderr == stderr &&
            other.exit_code == exit_code
      rescue NoMethodError
        false
      end
    end

    subject { described_class.new(stdout: "stdout\n", stderr: "stderr\n", exit_code: 0) }
    describe '#initialize' do
      it 'takes newline characters off of stdout and stderr' do
        expect(subject.stderr).to eq(:stderr.to_s)
        expect(subject.stdout).to eq(:stdout.to_s)
      end
    end

    describe '#to_s' do
      it 'gives a formatted representation of commandline output' do
        # rubocop:disable Layout/TrailingWhitespace
        expected_output = <<~OUTPUT
          EXIT CODE: #{subject.exit_code}
          
          STDOUT:
          #{subject.stdout}
          
          STDERR:
          #{subject.stderr}
        OUTPUT
        # rubocop:enable Layout/TrailingWhitespace

        expect(subject.to_s).to eq(expected_output)
      end

      describe '#error?' do
        context 'exit_code is 0' do
          subject { described_class.new(stdout: '', stderr: '', exit_code: 0) }
          it 'returns false' do
            expect(subject.error?).to eq(false)
          end
        end

        context 'exit_code is not 0' do
          subject { described_class.new(stdout: '', stderr: '', exit_code: 1) }
          it 'returns false' do
            expect(subject.error?).to eq(true)
          end
        end
      end
    end
  end
end
