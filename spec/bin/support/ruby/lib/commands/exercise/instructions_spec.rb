module Exercise
  describe Instructions do
    let(:output) { StringIO.new }
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
        let(:cmd) { 'bad command' }

        it 'raises an error' do
          expect { subject.command(cmd) }.to raise_error(CommandError)
        end

        context 'fail_on_error: false' do
          it 'does not raise an error' do
            expect { subject.command(cmd, fail_on_error: false) }.to_not raise_error
          end
        end
      end

      it 'returns the command string' do
        cmd = 'echo hello'
        expect(subject.command(cmd)).to eq(cmd)
      end
    end

    describe '#test_command' do
      let(:cmd) { 'echo hello' }

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
          let(:cmd) { 'bad command' }
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
          let(:cmd) { 'bad command' }
          it 'says there has been an error' do
            subject.test_command(cmd)
            expect(output.string).to include("ERROR] failed to run: #{cmd}")
          end
        end
      end
    end

    describe '#write_to_file' do
      require 'tmpdir'
      around do |spec|
        Dir.mktmpdir do |path|
          Dir.chdir(path) do
            spec.call
          end
        end
      end

      it 'writes content to the given path' do
        expected_path = 'a/path/file.txt'
        expected_content = 'content'
        expect(subject.write_to_file(expected_path, expected_content)).to eq(expected_path)

        expect(File.read(expected_path)).to eq(expected_content)
      end
    end
  end
end
