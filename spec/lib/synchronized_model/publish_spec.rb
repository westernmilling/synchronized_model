# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SynchronizedModel::Publish do
  class TestPublishModelClass
    include SynchronizedModel::PublishMixin

    attr_accessor :attributes

    def initialize(attributes)
      @attributes = attributes
    end
  end

  let(:expected_attributes) do
    { name: 'John Smith', visits: '12' }
  end
  let(:test_model) do
    TestPublishModelClass.new(expected_attributes)
  end
  let(:publish_handler) { spy }

  let(:instance) { described_class.new(test_model) }

  describe '#call' do
    before do
      allow(publish_handler)
        .to receive(:call)
      allow(SynchronizedModel)
        .to receive(:publish_handler)
        .and_return(publish_handler)
    end

    subject { instance.call }

    it 'calls publish handler with message' do
      subject

      expect(SynchronizedModel)
        .to have_received(:publish_handler)
      expect(publish_handler)
        .to have_received(:call)
        .with(instance_of(Hash))
    end
  end
end
