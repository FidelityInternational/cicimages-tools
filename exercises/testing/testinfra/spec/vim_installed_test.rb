# frozen_string_literal: true

describe package('node') do
  it { should be_installed }
end

describe package('vim') do
  it { should be_installed }
end
