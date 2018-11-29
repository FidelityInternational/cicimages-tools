
describe 'setup' do

  include_context :shell_spec, script_root: 'support/bin/'
  let(:stubbed_env) { create_stubbed_env }

  describe 'init' do
    context 'network does not exist' do
      it 'creates it' do
        stubbed_env.stub_command('network_exists').returns_exitstatus(1)
        create_network_function = stubbed_env.stub_command('create_network')

        expect(execute_function("init")).to_not have_error
        expect(create_network_function).to be_called_with_arguments('cic')

      end
    end
  end

  describe 'create_network' do
    it 'creates the network' do
      network_name = 'new_network'
      docker = stubbed_env.stub_command('docker')
      result = execute_function("create_network #{network_name}")

      expect(result).to_not have_error
      expect(docker).to be_called_with_arguments('network', 'create', network_name)
    end
  end

  describe 'network_exists' do
    context 'network exists' do
      it 'it passes' do
        stubbed_env.stub_command('docker').with_args('network', 'inspect', 'cic')
        result = execute_function('network_exists')
        expect(result).to_not have_error
      end
    end

    context 'network does not exist' do
      it 'it fails' do
        stubbed_env.stub_command('docker').with_args('network', 'inspect', 'cic').returns_exitstatus(1)
        result = execute_function('network_exists cic')
        expect(result).to have_error
      end
    end
  end


end