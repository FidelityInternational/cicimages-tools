shared_context :run_in_temp_directory do
  require 'tmpdir'
  around do |spec|
    current_dir = Dir.pwd
    Dir.mktmpdir do |path|
      Dir.chdir(path)
      spec.call
      Dir.chdir(current_dir)
    end
  end

  def write_to_file(path, content, mode: nil)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
    File.chmod(mode.to_i, path) if mode
    path
  end
end
