shared_context :command do
  let(:stdout) { StringIO.new }

  before(:each) do
    stdout = stdout()
    subject.define_singleton_method :output do
      stdout
    end
  end

end