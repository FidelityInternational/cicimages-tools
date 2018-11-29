describe 'init' do
  include_context :shell_spec, script_root: 'support/bin/'

  describe 'init' do
    it 'copies bin scripts the given location' do
      source_dir = "#{Dir.pwd}/source_dir"
      expected_bin_script = 'bin_script'
      FileUtils.mkdir_p source_dir
      FileUtils.touch("#{source_dir}/#{expected_bin_script}")

      target_dir = "#{Dir.pwd}/target_bin"
      FileUtils.mkdir_p target_dir

      result = execute_script([target_dir], 'BIN_PATH' => source_dir)

      expect(result).to_not have_error
      expect(File).to exist("#{target_dir}/#{expected_bin_script}")
    end
  end
end
