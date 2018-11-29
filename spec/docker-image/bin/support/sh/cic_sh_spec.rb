describe 'cic.sh' do
  include_context :shell_spec, script_root: 'support/bin/support/sh/functions'
  let(:stubbed_env) { create_stubbed_env }

  describe '#cic_working_directory' do
    context 'host machine' do
      it 'it returns the default directory' do
        expect(execute_function('cic_working_dir').stdout).to eq('/mnt/cic_working_dir')
      end
    end

    context 'within container' do
      it 'it returns the current working directory' do
        cic_working_dir = '/mnt/cic_working_dir/first/second'

        stubbed_env.stub_command('pwd').outputs(cic_working_dir, to: :stdout)

        expect(execute_function('cic_working_dir').stdout).to eq(cic_working_dir)
      end
    end
  end
  describe '#working_directory' do
    context 'call made on this host machine' do
      it 'returns the current working directory' do
        expect(execute_function('working_directory').stdout).to eq(Dir.pwd)
      end
    end

    context 'call made within cic tools container' do
      it 'returns the path' do
        child_dir = 'first/second'
        stubbed_env.stub_command('pwd').outputs("/mnt/cic_working_dir/#{child_dir}", to: :stdout)

        FileUtils.mkdir_p(child_dir)
        expected_dir = "#{Dir.pwd}/#{child_dir}"

        result = execute_function('working_directory', 'CIC_PWD' => Dir.pwd)
        expect(result.stdout).to eq(expected_dir)
      end
    end
  end
end
