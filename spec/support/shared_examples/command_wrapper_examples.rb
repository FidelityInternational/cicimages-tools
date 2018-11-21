shared_examples :command_wrapper do |command, wrapper_method|
  let(:expected_command) { "#{expected_environment} #{command}" }

  context 'command succeeds' do
    it 'runs docker compose with courseware env variables' do
      result = Commandline::Return.new(stdout: '', stderr: '', exit_code: 0)
      expect(subject).to receive(:run).with(expected_command).and_return(result)
      subject.public_send(wrapper_method)
    end

    it 'outputs stdout' do
      output = 'output'
      stderr = 'error'
      result = Commandline::Return.new(stdout: output, stderr: stderr, exit_code: 0)
      expect(subject).to receive(:run).with(expected_command).and_return(result)
      subject.public_send(wrapper_method)
      expect(stdout.string).to include(output)
      expect(stdout.string).to_not include(stderr)
    end
  end

  context 'command fails' do
    it 'runs docker compose with courseware env variables' do
      error = 'error'
      result = Commandline::Return.new(stdout: 'stdout', stderr: error, exit_code: 1)
      expect(subject).to receive(:run).with(expected_command).and_return(result)
      subject.public_send(wrapper_method)
      expect(stdout.string).to include(error)
    end
  end
end
