module Exercise
  describe Output do
    it 'inherits from string' do
      expect(described_class).to be < String
    end

    let(:string) { 'string' }

    subject do
      described_class.new(string)
    end

    describe '#to_ansible_output' do
      it 'returns an Output::Ansible object' do
        expected = described_class::Ansible.new(string)
        expect(subject.to_ansible_output).to be_a(expected.class)
          .and eq(expected)
      end
    end

    describe '#to_pytest_output' do
      it 'returns an Output::Ansible object' do
        expected = described_class::Pytest.new(string)
        expect(subject.to_pytest_output).to be_a(expected.class)
          .and eq(described_class::Pytest.new(string))
      end
    end

    describe '#to_cic_output' do
      it 'returns an Output::Ansible object' do
        expected = described_class::CIC.new(string)
        expect(subject.to_cic_output).to be_a(expected.class)
          .and eq(expected)
      end
    end
  end
end
