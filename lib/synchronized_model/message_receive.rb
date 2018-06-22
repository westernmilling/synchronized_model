# frozen_string_literal: true
module SynchronizedModel
  class MessageReceive
    attr_reader :message

    def initialize(message)
      @message = Hash[message.map { |k, v| [k.to_sym, v] }]
    end

    def call
      model = SynchronizedModel::ModelMessage.new(message).model
      model.record_timestamps = false
      if chronological_update?(model)
        model.save!
      else
        log_message = "Outdated message for #{model.class} " \
        "ID: #{model.id}"
        SynchronizedModel.logger.info(log_message)
      end
    end

    private

    def chronological_update?(model)
      !(model.updated_at_was && model.updated_at_was >= model.updated_at)
    end
  end
end
