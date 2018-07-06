module Commandline
  describe Output do
    subject do
      Object.new.tap { |o| o.extend(described_class) }
    end
    describe '#output' do
      it 'defaults to STDOUT' do
        expect(subject.output).to be(STDOUT)
      end
    end

    describe '#say' do
      let(:output) { StringIO.new('') }
      subject do
        Class.new do
          include Output

          def initialize(output)
            @output = output
          end
        end.new(output)
      end

      it 'uses the output' do
        subject.say('hello')
        expect(output.string).to eq("hello\n")
      end
    end

    describe '#error' do
      it 'it prefixes the message with ERROR' do
        message = 'message'
        expect(subject).to receive(:prefix).and_call_original
        expect(subject.error(message)).to eq("[ERROR] #{message}\n".red)
      end
    end

    describe '#ok' do
      context 'one line in message' do
        it 'it prefixes the message with OK' do
          message = 'message'
          expect(subject).to receive(:prefix).and_call_original
          expect(subject.ok(message)).to eq("[OK] #{message}\n".green)
        end
      end
    end

    describe '#prefix' do
      context 'one line in message' do
        it 'a appends the prefix' do
          message = 'message'
          expect(subject.prefix(message, :prefix)).to eq("prefix#{message}\n")
        end
      end

      context 'multiple lines in message' do
        it 'tabs in the message' do
          expected_message = <<~MESSAGE
            prefixLine 1
                  Line 2
          MESSAGE

          text = <<-TEXT
          Line 1
          Line 2
          TEXT
          expect(subject.prefix(text, :prefix)).to eq(expected_message.chomp)
        end
      end
    end
  end
end
