describe 'utils.sh' do
  include_context :shell_spec, script_root: 'support/bin/support/sh/functions'

  describe 'exit_unless_var_defined' do
    context 'var is not defined defined' do
      it 'errors' do
        result = execute_function('exit_unless_var_defined MY_VAR')
        expect(result).to have_error
        expect(result.stdout).to eq('please set MY_VAR')
      end
    end

    context 'var is defined' do
      it 'does not error' do
        result = execute_function('exit_unless_var_defined MY_VAR', 'MY_VAR' => 'value')
        expect(result).to_not have_error
        expect(result.stdout).to eq('')
      end
    end
  end

  describe 'exit_unless_file_exists' do
    require 'tempfile'

    context 'file exists' do
      it 'exits with a 0' do
        file = Tempfile.create
        result = execute_function("exit_unless_file_exists #{file.path}")
        expect(result).to_not have_error
      end
    end

    context 'file does not exist' do
      it 'errors' do
        result = execute_function('exit_unless_file_exists missing_path')
        expect(result).to have_error
      end
    end
  end

  describe 'exit_unless_directory_exists' do
    require 'tmpdir'

    context 'directory exists' do
      it 'exits with a 0' do
        Dir.mktmpdir do |path|
          result = execute_function("exit_unless_directory_exists #{path}")
          expect(result).to_not have_error
        end
      end
    end

    context 'directory does not exist' do
      it 'errors' do
        result = execute_function('exit_unless_directory_exists missing_path')
        expect(result).to have_error
      end
    end
  end
end
