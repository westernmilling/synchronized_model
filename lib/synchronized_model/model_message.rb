# frozen_string_literal: true
module SynchronizedModel
  class ModelMessage
    extend Support
    @resource_classes = {}

    class << self
      attr_accessor :resource_classes
    end

    attr_reader :resource, :payload

    def initialize(message)
      @resource = message[:resource]
      @payload = Hash[message[:payload].map { |k, v| [k.to_sym, v] }]
    end

    def model
      @model ||= resource_class.from_queue_payload(payload)
    end

    protected

    def resource_class
      SynchronizedModel.receive_resource_classes.fetch(
        resource.to_sym, NullModel
      )
    end

    class NullModel
      def self.from_queue_payload(_payload); NullModel.new; end

      def self.find_by(_hash); nil; end

      def save!; end

      def updated_at; nil; end
    end
  end
end
