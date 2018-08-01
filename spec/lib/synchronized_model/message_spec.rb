# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SynchronizedModel::Message do
  describe '#call' do
    let(:expected_payload) do
      { name: 'John Smith', visits: '12' }
    end
    let(:model) do
      TestModel = Struct.new(:to_message_payload)
      TestModel.new(expected_payload)
    end

    subject { SynchronizedModel::Message.new(model).call }

    it 'returns expected message hash' do
      result = subject

      expect(result[:id].length).to be(36)
      expect(result[:payload]).to eq(expected_payload)
      expect(result[:resource]).to eq('test_model')
    end
  end
end
