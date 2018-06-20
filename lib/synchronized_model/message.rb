# frozen_string_literal: true

require 'securerandom'
module SynchronizedModel
  class Message
    include Support
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def call
      message
    end

    protected

    def message
      {
        id: SecureRandom.uuid,
        payload: model.to_message_payload,
        resource: underscore(model.class.name)
      }
    end
  end
end
