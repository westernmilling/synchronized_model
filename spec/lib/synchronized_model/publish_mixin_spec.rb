# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SynchronizedModel::PublishMixin do
  class TestClass
    include SynchronizedModel::PublishMixin

    attr_accessor :attributes

    def initialize(attributes)
      @attributes = attributes
    end
  end

  describe '#to_message_payload' do
    let(:expected_attributes) do
      { name: 'John Smith', visits: '12' }
    end

    subject do
      TestClass.new(expected_attributes).to_message_payload
    end

    it 'returns attributes hash' do
      expect(subject).to eq(expected_attributes)
    end
  end
end
