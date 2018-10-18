# frozen_string_literal: true

module SynchronizedModel
  class MessageReceive
    attr_reader :message

    def initialize(message)
      @message = Hash[message.map { |k, v| [k.to_sym, v] }]
    end

    def call
      if model
        update_model
      else
        log_model_not_found
      end
    end

    private

    def update_model
      if chronological_update?(model)
        model.updated_at = updated_dates[:was]
        active_record? ? model.save! : model.save
      else
        log_message = "Outdated message for #{model.class} " \
        "ID: #{model.id}"
        SynchronizedModel.logger.info(log_message)
      end
    end

    def chronological_update?(_model)
      !(updated_dates[:was] && updated_dates[:was] >= updated_dates[:current])
    end

    def updated_dates
      if active_record?
        { was: model.updated_at_was, current: model.updated_at }
      else
        change = model.column_change(:updated_at)
        { was: change[0], current: change[1] }
      end
    end

    def active_record?
      model.respond_to? :updated_at_was
    end

    def model
      @model ||= SynchronizedModel::ModelMessage.new(message).model
    end

    def log_model_not_found
      log_message = "Skipped Message ID: #{message[:id]}. " \
      "No #{message[:resource]} model configured with SynchronizedModel"
      SynchronizedModel.logger.info(log_message)
    end
  end
end
