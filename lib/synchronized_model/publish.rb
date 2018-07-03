# frozen_string_literal: true

module SynchronizedModel
  class Publish
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def call
      message = SynchronizedModel::Message.new(model).call
      SynchronizedModel.publish_handler.call(message)
    end
  end
end
