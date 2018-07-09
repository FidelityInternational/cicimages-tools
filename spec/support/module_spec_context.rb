shared_context :module_spec do
  subject do
      Object.new.tap do |o|
        o.extend(described_class)
      end
    end
end