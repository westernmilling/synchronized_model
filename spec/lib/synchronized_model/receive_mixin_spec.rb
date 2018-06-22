# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SynchronizedModel::ReceiveMixin do
  class TestClass
    include SynchronizedModel::ReceiveMixin
    synchronized_model_receive
  end

  describe '.synchronized_model_receive' do
    subject do
      TestClass.new
    end

    it 'returns attributes hash' do
      subject

      expect(SynchronizedModel::ModelMessage.resource_classes)
        .to eq(test_class: TestClass)
    end
  end
end
