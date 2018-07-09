module Exercise

  #TODO - test quiet
  describe RenderMethods do

    include_context :command

    def create_template(template_name, content = 'template')
      FileUtils.mkdir_p('.templates')
      File.write(".templates/#{template_name}.erb", content)
      template_name
    end

    subject do
      Object.new.tap do |o|
        o.extend(described_class)
        o.define_singleton_method :after_all_commands do
          []
        end
        o.define_singleton_method :quiet? do
          true
        end
      end
    end

    describe '#render_exercises' do


      it 'renders all .erb templates found' do
        expected_file1 = create_template('template1.md')
        expected_file2 = create_template('template2.md')
        subject.render_exercises(Dir.pwd)
        expect(Dir["*.md"]).to match([expected_file2, expected_file1])
      end

      context 'command throws an error' do
        it 'prints the error' do
          create_template('template1.md', '<% command("bad_command")%>')
          subject.render_exercises(Dir.pwd)
          expect(stdout.string).to include("bad_command: command not found")
        end
      end

      context 'no error thrown' do
        it 'returns true' do
          create_template('template1.md')
          expect(subject.render_exercises(Dir.pwd)).to eq(true)
        end
      end

      context 'error thrown in template' do
        it 'returns false' do
          expected_file = create_template('template.md', '<% raise %>')
          expect(subject.render_exercises(Dir.pwd)).to eq(false)
          expect(File.exists?(expected_file)).to eq(false)
        end

        it 'still renders the others' do
          expected_file1 = create_template('template1.md')
          create_template('bad_template.md', '<% raise %>')
          expected_file2 = create_template('template2.md')
          expect(subject.render_exercises(Dir.pwd))
          expect(Dir["*.md"]).to match([expected_file2, expected_file1])
        end
      end
    end
  end
end