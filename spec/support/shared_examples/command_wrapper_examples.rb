shared_examples :command_wrapper do |command, wrapper_method|
  it 'runs docker compose with courseware env variables' do
    result = Commandline::Return.new(stdout: '', stderr: '', exit_code: 0)
    mock_command = instance_double(Commandline::Command)
    expect(Commandline::Command).to receive(:new).with(command, env: expected_environment).and_return(mock_command)
    expect(mock_command).to receive(:run).and_return(result)
    subject.public_send(wrapper_method)
  end
end
