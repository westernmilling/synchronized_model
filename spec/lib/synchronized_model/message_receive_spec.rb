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

    def save; end

    def updated_at; nil; end

    def uuid; nil; end

    def errors; []; end

    def updated_at=(_value); nil; end
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

    let(:mock_model_sequel) do
      model = TestModel.new
      allow(model).to receive(:save)
      allow(model).to receive(:updated_at).and_return(updated_at)
      allow(model).to receive(:column_change).and_return(
        [updated_at_was, updated_at]
      )
      allow(model).to receive(:additional_message_attributes).and_return(
        additional_key: 'Test message'
      )
      allow(model).to receive(:errors).and_return(errors)
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
      allow(SynchronizedModel::ModelMessage)
        .to receive(:new)
        .and_return(mock_message_model)
    end

    subject { SynchronizedModel::MessageReceive.new(message).call }

    context 'with a Sequel model' do
      before do
        allow(mock_message_model)
          .to receive(:model).and_return(mock_model_sequel)
      end

      context 'it\'s a chronological_update' do
        let(:updated_at_was) { Time.now }
        let(:updated_at) { (Time.now + 1) }
        let(:errors) { [] }

        it 'calls save' do
          subject
          expect(mock_model_sequel).to have_received(:save)
          expect(mock_model_sequel.updated_at).to eq(updated_at)
        end

        it 'raises an error if validations fail' do
          errors << ['error']

          expect { subject }.to raise_error(RuntimeError)
        end
      end
    end

    context 'with an ActiveRecord model' do
      before do
        allow(mock_message_model).to receive(:model).and_return(mock_model)
      end

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

      context "the model isn't configured" do
        let(:updated_at_was) { nil }
        let(:updated_at) { nil }
        let(:expected_log_message) do
          "Skipped Message ID: #{message[:id]}. " \
          "No #{message[:resource]} model configured with SynchronizedModel"
        end
        let(:logger_spy) { spy }
        let(:mock_model) { nil }

        before do
          allow(SynchronizedModel)
            .to receive(:logger)
            .and_return(logger_spy)
          allow(logger_spy)
            .to receive(:info)
        end

        it 'logs that the model was not configured' do
          subject

          expect(SynchronizedModel)
            .to have_received(:logger)
          expect(logger_spy)
            .to have_received(:info)
            .with(expected_log_message)
        end
      end
    end
  end
end
