module Exercise

  #TODO - test quiet
  describe RenderMethods do

    include_context :command
    include_context :module_spec

    def create_template(rendered_filepath: "#{rand(99999)}.md", content: 'template')
      template_fixture = Struct.new(:path, :expected_rendered_filepath)
      FileUtils.mkdir_p('.templates')
      template_path = ".templates/#{rendered_filepath}.erb"
      File.write(template_path, content)
      template_fixture.new(template_path, rendered_filepath)
    end

    before(:each) do
      subject.define_singleton_method :quiet? do
        true
      end
    end


    describe '#render_exercise' do
      describe 'console output' do
        include Commandline::Output

        let(:exercise_name){File.basename(File.expand_path("#{Dir.pwd}/.templates/../"))}

        context 'quiet' do
          context 'rendering succeeds' do
            it 'prints a quiet report' do
              expected_output = "Generating file for: #{exercise_name}\n\n#{ok("Finished: #{exercise_name}")}"
              subject.render_exercise(Dir.pwd, create_template.path)
              expect(subject.output.string.chomp).to eq(expected_output)
            end
          end

          context 'rendering fails' do
            it 'prints a quiet report' do
              allow_any_instance_of(Commandline::Return).to receive(:to_s).and_return("error")
              allow(subject).to receive(:render).and_raise(CommandError)

              template = create_template(content: '<% command("bad_command")%>')

              expected_output = "Generating file for: #{exercise_name}\n#{error("Failed to generate file from: #{template.path}")}"

              expect{subject.render_exercise(Dir.pwd, template.path)}.to raise_error(CommandError)
              expect(subject.output.string.chomp).to eq(expected_output)
            end
          end
        end

        context 'not quiet' do
          before(:each) do
            allow(subject).to receive(:quiet?).and_return(false)
          end

          context 'rendering succeeds' do
            it 'prints a quiet report' do
              expected_output = "Generating file for: #{exercise_name}\n#{ok("Finished: #{exercise_name}")}"
              subject.render_exercise(Dir.pwd, create_template.path)
              expect(subject.output.string.chomp).to eq(expected_output)
            end
          end
        end
      end
    end

    describe '#render_exercises' do
      it 'renders all .erb templates found' do
        template1 = create_template
        template2 = create_template
        subject.render_exercises(Dir.pwd)
        expect(Dir["*.md"]).to match_array([template1.expected_rendered_filepath, template2.expected_rendered_filepath])
      end

      context 'no error thrown' do
        it 'returns true' do
          create_template
          expect(subject.render_exercises(Dir.pwd)).to eq(true)
        end
      end

      context 'error thrown in template' do
        it 'returns false' do
          expected_file = create_template(content: '<% raise %>')
          expect(subject.render_exercises(Dir.pwd)).to eq(false)
          expect(File.exists?(expected_file.expected_rendered_filepath)).to eq(false)
        end

        it 'still renders the others' do
          expected_file1 = create_template
          create_template(content: '<% raise %>')
          expected_file2 = create_template
          expect(subject.render_exercises(Dir.pwd))
          expect(Dir["*.md"]).to match_array([expected_file1.expected_rendered_filepath, expected_file2.expected_rendered_filepath])
        end
      end
    end
  end
end