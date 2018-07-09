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
          subject.options = {quiet: true}
          expect(subject.quiet?).to eq(true)
        end
      end

      context 'option set to false' do
        it 'returns false' do
          subject.options = {quiet: false}
          expect(subject.quiet?).to eq(false)
        end
      end

      it 'defaults to false' do
        expect(subject.quiet?).to eq(false)
      end
    end

    describe 'generate' do

      it 'generates exercises for the current directory' do
        expect(subject).to receive(:render_exercises).with(Dir.pwd).and_return(true)
        subject.generate
      end

      context 'rendering fails' do
        it 'raises and error' do
          expect(subject).to receive(:render_exercises).with(Dir.pwd).and_return(false)
          expect{subject.generate}.to raise_error(Thor::Error)
        end
      end

    end
  end
end