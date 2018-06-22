# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SynchronizedModel::ModelMessage do
  class TestClass
    def self.from_queue_payload(payload)
      { title: payload[:title] }
    end
  end

  let(:payload) { { 'title': 'Title' } }

  it 'can be initialized with a hash' do
    msg = described_class.new(resource: 'test_class', payload: payload)
    expect(msg.resource).to eql('test_class')
  end

  describe '#model' do
    let(:message_attributes) do
      {
        resource: resource,
        payload: payload
      }
    end
    let(:payload) { { title: 'Title' } }

    before do
      SynchronizedModel.configure do |config|
        config.receive_resource_classes =
          {
            'test_class': TestClass
          }
      end
    end

    subject { described_class.new(message_attributes) }

    context 'with a valid resource name' do
      let(:resource) { 'test_class' }

      it 'initializes the model with the payload' do
        expect(subject.model[:title]).to eq(payload[:title])
      end
    end
  end
end
