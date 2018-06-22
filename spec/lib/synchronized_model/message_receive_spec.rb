# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SynchronizedModel::MessageReceive do
  class TestModel
    include SynchronizedModel::PublishMixin

    def attributes
      {}
    end

    def id; 123; end

    def record_timestamps=(boolean); end

    def self.from_queue_payload(_payload); end

    def self.find_by(_hash); nil; end

    def save!; end

    def updated_at; nil; end
  end

  describe '#call' do
    let(:message) do
      SynchronizedModel::Message.new(model).call
    end
    let(:model) do
      TestModel.new
    end

    let(:mock_model) do
      model = TestModel.new
      allow(model).to receive(:save!)
      allow(model).to receive(:updated_at_was).and_return(updated_at_was)
      allow(model).to receive(:updated_at).and_return(updated_at)
      model
    end

    let(:logger_mock) do
      logger = double
      allow(logger).to receive(:info)
      logger
    end

    let(:mock_message_model) { double }

    before do
      SynchronizedModel.configure do |config|
        config.logger = logger_mock
        config.receive_resource_classes =
          {
            'test_model': TestModel
          }
      end
      allow(mock_message_model)
        .to receive(:model)
        .and_return(mock_model)
      allow(SynchronizedModel::ModelMessage)
        .to receive(:new)
        .and_return(mock_message_model)
    end

    subject { SynchronizedModel::MessageReceive.new(message).call }

    context 'it\'s a chronological_update' do
      let(:updated_at_was) { Time.now.to_i }
      let(:updated_at) { Time.now.to_i + 100 }

      it 'calls save!' do
        subject

        expect(mock_model).to have_received(:save!)
      end
    end

    context 'the message is older than the model' do
      let(:updated_at_was) { Time.now.to_i + 10_000 }
      let(:updated_at) { Time.now.to_i }

      it 'does not call save!' do
        subject

        expect(mock_model).to_not have_received(:save!)
      end
    end

    context 'the message is the same age as the model' do
      let(:updated_at_was) { Time.now.to_i }
      let(:updated_at) { Time.now.to_i }

      it 'does not call save!' do
        subject

        expect(mock_model).to_not have_received(:save!)
      end
    end
  end
end
