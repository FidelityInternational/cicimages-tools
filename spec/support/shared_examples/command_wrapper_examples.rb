shared_examples :command_wrapper do |command, wrapper_method|
  let(:expected_command) { "#{expected_environment} #{command}" }

  it 'runs docker compose with courseware env variables' do
    result = Commandline::Return.new(stdout: '', stderr: '', exit_code: 0)
    mock_command = instance_double(Commandline::Command)
    expect(Commandline::Command).to receive(:new).with(expected_command).and_return(mock_command)
    expect(mock_command).to receive(:run).and_return(result)
    subject.public_send(wrapper_method)
  end
end
