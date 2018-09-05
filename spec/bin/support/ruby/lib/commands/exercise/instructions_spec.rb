module Exercise
  describe Instructions do
    include_context :command
    include_context :module_spec

    before(:each) do
      subject.define_singleton_method :quiet? do
        true
      end
    end

    describe '#after_rendering_run' do
      it 'registers the given command to be run later' do
        command = :command
        subject.after_rendering_run(command)
        expect(subject.send(:after_rendering_commands)).to eq([:command])
      end

      it 'returns the given command' do
        expect(subject.after_rendering_run(:command)).to eq(:command)
      end
    end

    describe '#cd' do
      let(:expected_directory) do
        "#{Dir.pwd}/test".tap do |path|
          FileUtils.mkdir(path)
        end
      end

      it 'changes the current directory' do
        subject.cd(expected_directory)
        expect(Dir.pwd).to eq(expected_directory)
      end

      it 'returns the command for changing directory' do
        expect(subject.cd(expected_directory)).to eq("cd #{expected_directory}")
      end
    end

    describe '#command_output' do
      it 'returns the output from running the command' do
        expect(subject).to receive(:last_command_output).and_call_original
        expect(subject.command_output('echo hello')).to eq('hello')
      end
    end

    describe '#last_command_output' do
      it 'returns the output of the last command' do
        subject.command_output('echo hello')
        expected_output = Exercise::Output.new('hello')
        expect(subject.last_command_output).to be_a(expected_output.class).and eq(expected_output)
      end
    end

    describe '#path' do
      context 'path exists' do
        it 'returns the given path' do
          expect(subject.path(Dir.pwd)).to eq(Dir.pwd)
        end
      end

      context 'path does not exist' do
        it 'raises and error' do
          expect { subject.path('missing') }.to raise_error(RuntimeError)
        end
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

      context 'console output' do
        include Commandline::Output

        context 'quiet' do
          before :each do
            allow(subject).to receive(:quiet?).and_return(true)
          end

          context 'command passes' do
            it 'prints out a quiet report' do
              subject.send(:test_command, cmd)
              expect(subject.output.string).to eq('.'.green)
            end
          end

          context 'command fails' do
            let(:cmd) { 'bad command' }

            it 'says there has been an error' do
              allow_any_instance_of(Commandline::Return).to receive(:to_s).and_return('error')
              expected_error = error("failed to run: #{cmd}\n\nerror")
              subject.send(:test_command, cmd)
              expect(subject.output.string.chomp).to eq(expected_error)
            end
          end
        end

        context 'not quiet' do
          before :each do
            allow(subject).to receive(:quiet?).and_return(false)
          end

          context 'command passes' do
            it 'reports the command that has run' do
              expected_message = "running: #{cmd}\n#{ok("Successfully ran: #{cmd}")}"

              subject.send(:test_command, cmd)
              expect(subject.output.string.chomp).to eq(expected_message)
            end
          end

          context 'command fails' do
            let(:cmd) { 'bad command' }
            it 'says there has been an error' do
              allow_any_instance_of(Commandline::Return).to receive(:to_s).and_return('error')
              expected_message = "running: #{cmd}\n#{error("failed to run: bad command\n\n error")}"

              subject.send(:test_command, cmd)
              expect(subject.output.string.chomp).to eq(expected_message)
            end
          end
        end
      end
    end

    describe '#write_to_file' do
      it 'writes content to the given path' do
        expected_path = 'a/path/file.txt'
        expected_content = 'content'
        expect(subject.write_to_file(expected_path, expected_content)).to eq(expected_path)

        expect(File.read(expected_path)).to eq(expected_content)
      end
    end
  end
end
