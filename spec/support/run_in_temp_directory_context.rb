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
end
