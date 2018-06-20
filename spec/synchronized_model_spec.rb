# frozen_string_literal: true

RSpec.describe SynchronizedModel do
  it 'has a version number' do
    expect(SynchronizedModel::VERSION).not_to be nil
  end
end
