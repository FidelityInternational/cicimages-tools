describe 'course_content.rake' do
  include_context :templates
  include_context :rake

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
        write_to_file(template.expected_rendered_filepath, Digest::SHA2.file(template.path).hexdigest)

        expect { subject.execute(path: Dir.pwd) }.to_not raise_error
      end
    end
  end
end
