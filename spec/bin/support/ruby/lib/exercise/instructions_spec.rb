module Exercise
  describe Instructions do

    let(:output){StringIO.new}
    subject do
      Object.new.tap do |o|
        o.extend(described_class)
        def o.quiet?
          true
        end

        allow(o).to receive(:output).and_return(output)
      end
    end

    describe '#command' do
      context 'command fails' do
        it 'raises an error' do
          cmd = 'bad command'
          expect{subject.command(cmd)}.to raise_error(CommandError)
        end
      end

      it 'returns the command string' do
        cmd = 'echo hello'
        expect(subject.command(cmd)).to eq(cmd)
      end
    end

    describe '#test_command' do

      let(:cmd){'echo hello'}

      context 'not quiet' do

        before do
          allow(subject).to receive(:quiet?).and_return(true)
        end

        it 'prints out the command that is running' do
          allow(subject).to receive(:quiet?).and_return(false)
          subject.test_command(cmd)
          expect(output.string.uncolorize).to include("running: #{cmd}")
        end

        context 'command passes' do
          it 'reports the command that has run' do
            allow(subject).to receive(:quiet?).and_return(false)
            subject.test_command(cmd)
            expect(output.string.uncolorize).to include("[OK] Successfully ran: #{cmd}")
          end
        end

        context 'command fails' do
          let(:cmd){'bad command'}
          it 'says there has been an error' do
            subject.test_command(cmd)
            expect(output.string).to include("ERROR] failed to run: #{cmd}")
          end
        end
      end

      context 'quiet' do
        before do
          allow(subject).to receive(:quiet?).and_return(true)
        end

        context 'command passes' do
          it 'prints a dot' do
            subject.test_command(cmd)
            expect(output.string.uncolorize).to eq('.')
          end
        end

        context 'command fails' do
          let(:cmd){'bad command'}
          it 'says there has been an error' do
            subject.test_command(cmd)
            expect(output.string).to include("ERROR] failed to run: #{cmd}")
          end
        end

      end
    end
  end
end