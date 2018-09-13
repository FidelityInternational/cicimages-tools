describe 'course_content.rake' do
  include_context :templates
  include_context :rake

  context 'course_content:generate' do
    before :each do
      ENV['SILENT'] = 'true'
    end
    let(:task) { 'course_content:generate' }

    def files(matcher)
      Dir[matcher].collect { |f| File.expand_path(f) }
    end

    context 'error in template' do
      it 'still renders the others' do
        expected_file1 = create_template
        bad_template = create_template(content: '<% raise %>')
        expected_file2 = create_template

        expect { subject.execute(path: Dir.pwd) }.to raise_error do |exception|
          expect(exception).to be_a(CourseContentRenderingError)

          expected_file_list = [File.expand_path(bad_template.path)]
          expect(exception.message).to eq(CourseContentRenderingError.new(expected_file_list).message)
        end

        expect(files('*.md')).to match_array([expected_file1.expected_rendered_filepath,
                                              expected_file2.expected_rendered_filepath])
      end
    end

    context 'no error in template' do
      let!(:template) { create_template }

      it 'renders the template' do
        subject.execute(path: Dir.pwd)
        expect(File).to exist(template.expected_rendered_filepath)
      end
    end

    context 'rendered file based on latest template' do
      it 'does not re-render the template' do
        create_template
        expect(subject).to_not receive(:run).and_call_original
        subject.execute(path: Dir.pwd)

        expect(subject).to_not receive(:run)
        subject.execute(path: Dir.pwd)
      end
    end
  end

  context 'course_content:checksum' do
    let(:task) { 'course_content:checksum' }
    let(:template) { create_template }

    context 'generated file is not based on latest version of template' do
      it 'raise an error' do
        write_to_file(template.expected_rendered_filepath, 'out of date')

        expect { subject.execute(path: Dir.pwd) }.to raise_error do |exception|
          expect(exception).to be_a(CourseContentOutOfDateError)

          expected_file_list = File.expand_path(template.expected_rendered_filepath)
          expect(exception.message).to eq(CourseContentOutOfDateError.new([expected_file_list]).message)
        end
      end
    end

    context 'generated files are up to date' do
      it 'does not raise an error' do
        Rake::Task['course_content:generate'].execute(path: Dir.pwd)
        expect { subject.execute(path: Dir.pwd) }.to_not raise_error
      end
    end
  end
end
