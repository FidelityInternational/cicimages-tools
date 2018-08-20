module Exercise
  describe RenderMethods do
    include_context :command
    include_context :module_spec
    include_context :templates

    before(:each) do
      subject.define_singleton_method :quiet? do
        true
      end
    end

    describe '#exercise_path' do
      it 'returns the directory that the render_methods starts in' do
        expected_path = 'expected'
        subject.render_exercises(dir: Dir.pwd, pretty_exercise_path: expected_path)
        expect(subject.exercise_path).to eq(expected_path)
      end
    end

    describe '#render_exercise' do
      describe 'console output' do
        include Commandline::Output

        let(:exercise_name) { File.basename(File.expand_path("#{Dir.pwd}/.templates/../")) }

        it 'makes subsitutions' do
          template = create_template(content: '<% substitute("foo" => "bar")%>foo')
          subject.render_exercise(Dir.pwd, template.path)

          rendered_content = File.read(template.expected_rendered_filepath)
          expect(rendered_content).to include('bar')
        end

        it 'adds the revision to the end of the file' do
          template = create_template
          subject.render_exercise(Dir.pwd, template.path)

          rendered_content = File.read(template.expected_rendered_filepath)
          expected_digest = Digest::SHA2.file(template.path).hexdigest

          expect(rendered_content).to end_with("  \n\nRevision: #{expected_digest}")
        end

        context 'quiet' do
          context 'rendering succeeds' do
            it 'prints a quiet report' do
              expected_output = "Generating file for: #{exercise_name}\n\n#{ok("Finished: #{exercise_name}")}"
              subject.render_exercise(exercise_name, create_template.path)
              expect(subject.output.string.chomp).to eq(expected_output)
            end
          end

          context 'rendering fails' do
            it 'prints a quiet report' do
              allow_any_instance_of(Commandline::Return).to receive(:to_s).and_return('error')
              command_error = CommandError.new
              allow(subject).to receive(:render).and_raise(command_error)

              template = create_template(content: '<% command("bad_command")%>')

              subject.render_exercise(exercise_name, template.path)

              expected_error = error("Failed to generate file from: #{template.path}")
              backtrace = "#{command_error.message}\n#{command_error.backtrace}"
              expected_output = "Generating file for: #{exercise_name}\n#{expected_error}\n#{backtrace}"

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
              subject.render_exercise(exercise_name, create_template.path)
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
        subject.render_exercises(dir: Dir.pwd)
        expect(Dir['*.md']).to match_array([template1.expected_rendered_filepath,
                                            template2.expected_rendered_filepath])
      end

      context 'no error thrown' do
        it 'returns true' do
          create_template
          expect(subject.render_exercises(dir: Dir.pwd)).to eq(true)
        end
      end

      context 'error thrown in template' do
        it 'returns false' do
          expected_file = create_template(content: '<% raise %>')
          expect(subject.render_exercises(dir: Dir.pwd)).to eq(false)
          expect(File.exist?(expected_file.expected_rendered_filepath)).to eq(false)
        end

        it 'still renders the others' do
          expected_file1 = create_template
          create_template(content: '<% raise %>')
          expected_file2 = create_template
          expect(subject.render_exercises(dir: Dir.pwd))
          expect(Dir['*.md']).to match_array([expected_file1.expected_rendered_filepath,
                                              expected_file2.expected_rendered_filepath])
        end
      end
    end
  end
end
