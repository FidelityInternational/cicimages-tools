shared_context :rake do
  require 'rake'

  let(:task) { raise "you must provide a let for 'task'" }
  before do
    rake_application = Rake::Application.new
    rake_application.add_import("#{__dir__}/../../../tasks/#{self.class.top_level_description}")
    rake_application.load_imports
  end

  after do
    subject.reenable
  end

  subject do
    Rake::Task[task]
  end
end
