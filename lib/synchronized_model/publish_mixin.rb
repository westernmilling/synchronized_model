# frozen_string_literal: true

module SynchronizedModel
  module PublishMixin
    def to_message_payload
      attributes
    end
  end
end
