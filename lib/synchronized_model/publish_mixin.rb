# frozen_string_literal: true

module SynchronizedModel
  module PublishMixin
    def to_message_payload
      attributes.merge(additional_message_attributes)
    end

    private

    # This method can be overriden in the model to attach additional
    # attributes to the message
    def additional_message_attributes
      {}
    end
  end
end
