module Exercise
  describe Command do
    describe '.exit_on_failure?' do
      it 'returns true' do
        expect(described_class.exit_on_failure?).to eq(true)
      end
    end

    include_context :command

    describe '#quiet?' do
      context 'option set to true' do
        it 'returns true' do
          subject.options = { quiet: true }
          expect(subject.quiet?).to eq(true)
        end
      end

      context 'option set to false' do
        it 'returns false' do
          subject.options = { quiet: false }
          expect(subject.quiet?).to eq(false)
        end
      end

      it 'defaults to false' do
        expect(subject.quiet?).to eq(false)
      end
    end

    # TODO: - put the #on the method name
    describe 'generate' do
      it 'generates content from the given template' do
        template_path = '/path'
        expect(subject).to receive(:render_exercise).with(template_path).and_return(true)
        subject.generate(template_path)
      end

      context 'rendering fails' do
        it 'raises and error' do
          template_path = '/path'
          expect(subject).to receive(:render_exercise).with(template_path).and_return(false)
          expect { subject.generate(template_path) }.to raise_error(Thor::Error)
        end
      end
    end

    describe '#create' do
      let(:exercise_name) { 'new_exercise' }
      let(:scaffold_path) { ENV['SCAFFOLD_PATH'] = 'scaffold' }

      let(:config) do
        { 'directories' => %w[dir1 dir2] }
      end

      let!(:scaffold_structure_path) do
        ENV['SCAFFOLD_STRUCTURE'] = write_to_file("#{scaffold_path}/exercise_structure_path", config.to_yaml)
      end

      it 'creates the directories in the given config' do
        subject.create exercise_name
        config['directories'].each do |directory|
          expect(Dir).to exist("#{exercise_name}/#{directory}")
        end
      end

      it 'copies the files and folders at the SCAFFOLD PATH' do
        template = 'dir1/dir2/file.txt'
        path = write_to_file("#{scaffold_path}/#{template}", 'content')
        subject.create exercise_name
        expect(File.read(path)).to eq(File.read("#{exercise_name}/#{template}"))
      end

      it 'lists the files and directories created' do
        template = 'dir1/dir2/file.txt'
        write_to_file("#{scaffold_path}/#{template}", 'content')
        subject.create exercise_name
        expect(stdout.string).to include("Created: #{exercise_name}/#{template}")
        expect(stdout.string).to include("Created: #{exercise_name}/#{config['directories'].first}")
      end

      it 'doesnt report that it has created . and ..' do
        subject.create exercise_name
        expect(stdout.string).to_not include("Created: #{exercise_name}/.")
      end
    end
  end
end
