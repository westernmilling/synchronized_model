# frozen_string_literal: true
require 'spec_helper'
require 'pry-byebug'

RSpec.describe SynchronizedModel::ReceiveMixin do
  class TestModelReceive
    include SynchronizedModel::ReceiveMixin
    synchronized_model_receive
  end

  describe '.synchronized_model_receive' do
    subject do
      TestModel.new
    end

    it 'returns attributes hash' do
      subject

      expect(
        SynchronizedModel::ModelMessage.resource_classes[:test_model_receive]
      )
        .to eq(TestModelReceive)
    end
  end
end
