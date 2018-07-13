module Commands
  module Track
    describe Exercise do
      let(:track) { 'track' }
      let(:name) { 'exercise' }
      let(:path) { Dir.pwd }
      subject do
        described_class.new(track: track, name: name, path: path)
      end

      describe '#detail' do
        it 'includes a link to the exercise' do
          expected_msg = "[Click here](../tree/master/#{subject.path}) to read the #{subject.name} exercise"
          expect(subject.detail).to eq(expected_msg)
        end

        context 'preamble present' do
          it 'includes the preamble' do
            preamble = 'preamble'
            write_to_file("#{subject.track}/#{subject.name}.md", preamble)
            expect(subject.detail).to start_with(preamble)
          end
        end
      end
      describe '#validate' do
        context 'path and name ok' do
          it 'it does not throw an error' do
            expect { subject.validate }.to_not raise_error
          end
        end
        context 'path does not exist' do
          let(:path) { 'missing' }
          it 'throws an error' do
            expect { subject.validate }.to raise_error(ArgumentError, subject.path_error_msg)
          end
        end

        context 'name empty' do
          let(:name) { nil }
          it 'throws an error' do
            subject = described_class.new(track: 'track', name: nil, path: 'missing')
            expect { subject.validate }.to raise_error(ArgumentError, subject.name_error_msg)
          end
        end
      end
    end
  end
end
