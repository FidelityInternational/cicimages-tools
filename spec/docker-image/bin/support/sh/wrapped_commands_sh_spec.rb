describe 'wrapped_commands.sh' do
  include_context :shell_spec, script_root: 'support/bin/support/sh/functions'

  describe '#content_before' do
    it 'returns the content before the given delimeter' do
      input = 'a=b'
      result = execute("echo #{input} | content_before '='")
      expect(result).to_not have_error
      expect(result.stdout).to eq('a')
    end
  end

  describe '#content_after' do
    it 'returns the content after the given delimeter' do
      input = 'a=b'
      result = execute("echo #{input} | content_after '='")
      expect(result).to_not have_error
      expect(result.stdout).to eq('b')
    end
  end

  describe '#sanitise_value' do
    context 'value surrounded with double quotes' do
      it 'leaves the value alone' do
        value = 'value'
        result = execute_function(%(sanitise_value  "\"#{value}\""))
        expect(result).to_not have_error
        expect(result.stdout).to eq(%(\"#{value}\"))
      end
    end

    context 'value not surrounded with double quotes' do
      it 'surrounds the value with double quotes' do
        value = 'value'
        result = execute_function(%(sanitise_value  "#{value}"))
        expect(result).to_not have_error
        expect(result.stdout).to eq(%(\"#{value}\"))
      end
    end
  end

  describe '#sanitise_option' do
    context 'option is in format: option=value' do
      it 'surrounds the value with quotes' do
        input = '--option=value'
        result = execute_function(%(sanitise_option #{input}))
        expect(result).to_not have_error
        expect(result.stdout).to eq('--option="value"')
      end
    end

    context 'option is in format: option="value"' do
      it 'leaves everything alone' do
        input = '--option="value"'
        result = execute_function(%(sanitise_option #{input}))
        expect(result).to_not have_error
        expect(result.stdout).to eq(input)
      end
    end

    context 'option is in format: option="key=value"' do
      it 'leaves everything alone' do
        input = '--option="key=value"'
        result = execute_function(%(sanitise_option #{input}))
        expect(result).to_not have_error
        expect(result.stdout).to eq(input)
      end
    end
  end

  describe '#build_command' do
    it 'quotes options in the command' do
      input = "command --this=that --foo='bar'"
      result = execute_function(%(build_command #{input}))
      expect(result).to_not have_error
      expect(result.stdout).to eq('command --this="that" --foo="bar"')
    end
  end

  describe '#run_wrapped_command' do
    it 'calls docker with the required parameters' do
      docker = stubbed_env.stub_command('docker')
      stubbed_env.stub_command('standard_docker_options').outputs('standard_options', to: :stdout)

      result = execute_function('run_wrapped_command image command args')

      expect(result).to_not have_error
      expected_args = ['run', 'standard_options', 'image', '/bin/bash', '-ilc', 'command args']
      expect(docker).to be_called_with_arguments(*expected_args)
    end
  end
end
