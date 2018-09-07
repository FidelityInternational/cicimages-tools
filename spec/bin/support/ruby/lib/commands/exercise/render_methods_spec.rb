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

    describe '#env' do
      before do
        ENV['foo'] = 'bar'
      end
      context 'variable exists' do
        it 'returns the value' do
          expect(subject.env('foo')).to eq('bar')
        end
      end

      context 'non string supplied' do
        it 'returns the variable' do
          expect(subject.env(:foo)).to eq('bar')
        end
      end

      context 'variable name does not exist' do
        it 'raises an error' do
          expect{subject.env(:baz)}.to raise_error(described_class::EnvironmentVariableMissingError)
        end
      end
    end

    describe '#render_exercise' do
      describe 'console output' do
        include Commandline::Output

        let(:exercise_name) { File.basename(File.expand_path("#{Dir.pwd}/.templates/../")) }

        it 'makes subsitutions' do
          template = create_template(content: '<% substitute("foo" => "bar")%>foo')
          subject.render_exercise(template.path)

          rendered_content = File.read(template.expected_rendered_filepath)
          expect(rendered_content).to include('bar')
        end

        it 'adds the revision to the end of the file' do
          template = create_template
          subject.render_exercise(template.path)

          rendered_content = File.read(template.expected_rendered_filepath)
          expected_digest = Digest::SHA2.file(template.path).hexdigest

          expect(rendered_content).to end_with("  \n\nRevision: #{expected_digest}")
        end

        context 'quiet' do
          context 'rendering succeeds' do
            it 'prints a quiet report' do
              template = create_template
              expected_output = "Rendering: #{template.path}\n\n#{ok("Finished: #{template.path}")}"
              subject.render_exercise(template.path)
              expect(subject.output.string.chomp).to eq(expected_output)
            end
          end

          context 'rendering fails' do
            it 'prints a quiet report' do
              allow_any_instance_of(Commandline::Return).to receive(:to_s).and_return('error')
              command_error = CommandError.new
              allow(subject).to receive(:render).and_raise(command_error)

              template = create_template(content: '<% command("bad_command")%>')

              subject.render_exercise(template.path)

              expected_error = error("Failed to generate file from: #{template.path}")
              backtrace = "#{command_error.message}\n#{command_error.backtrace}"
              expected_output = "Rendering: #{template.path}\n#{expected_error}\n#{backtrace}"

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
              template = create_template
              expected_output = "Rendering: #{template.path}\n#{ok("Finished: #{template.path}")}"
              subject.render_exercise(template.path)
              expect(subject.output.string.chomp).to eq(expected_output)
            end
          end
        end
      end

      describe 'run_in_temp_directory directive' do
        it 'renders the template in the scope of a temporary directory' do
          expected_text = 'number of files: %d'
          content = <<~CONTENT
            <%# instruction:run_in_temp_directory%>
            <%= '#{expected_text}' % Dir['*.*'].size %>
CONTENT

          write_to_file('temp.file', 'content')
          template = create_template(content: content)
          subject.render_exercise(template.path)
          expect(File.read(template.expected_rendered_filepath)).to include(expected_text % 0)
        end
      end
    end
  end
end
