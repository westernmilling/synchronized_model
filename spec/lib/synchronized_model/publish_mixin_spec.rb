# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SynchronizedModel::PublishMixin do
  class TestClassWithNoAdditionalAttributes
    include SynchronizedModel::PublishMixin

    attr_accessor :attributes

    def initialize(attributes)
      @attributes = attributes
    end
  end

  class TestClassWithAdditionalAttributes
    include SynchronizedModel::PublishMixin

    attr_accessor :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def additional_message_attributes
      { title: 'Senior' }
    end
  end

  class SequelTestClassWithAdditionalAttributes
    include SynchronizedModel::PublishMixin

    attr_accessor :values

    def initialize(values)
      @values = values
    end

    def additional_message_attributes
      { title: 'Senior' }
    end
  end

  describe '#to_message_payload' do
    let(:expected_attributes) do
      { name: 'John Smith', visits: '12' }
    end

    context 'with no additional attributes' do
      subject do
        TestClassWithNoAdditionalAttributes
          .new(expected_attributes)
          .to_message_payload
      end

      it 'returns attributes hash' do
        expect(subject).to eq(expected_attributes)
      end
    end

    context 'with additional attributes' do
      let(:expected_additional_attributes) do
        { title: 'Senior' }
      end

      subject do
        TestClassWithAdditionalAttributes
          .new(expected_attributes)
          .to_message_payload
      end

      it 'returns attributes hash' do
        expect(subject)
          .to  eq(expected_attributes.merge(expected_additional_attributes))
      end
    end

    context 'with additional attributes on a Sequel model' do
      let(:expected_additional_attributes) do
        { title: 'Senior' }
      end

      subject do
        SequelTestClassWithAdditionalAttributes
          .new(expected_attributes)
          .to_message_payload
      end

      it 'returns attributes hash' do
        expect(subject)
          .to  eq(expected_attributes.merge(expected_additional_attributes))
      end
    end
  end
end
