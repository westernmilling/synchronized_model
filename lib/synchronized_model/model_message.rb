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
      @payload = message[:payload]
    end

    def model
      @model ||= resource_class.from_queue_payload(payload)
    end

    def self.add_resource_class(klass)
      underscored_name = underscore(klass.name).to_sym
      resource_classes[underscored_name] = klass
    end

    protected

    def resource_class
      self.class.resource_classes.fetch(resource.to_sym, NullModel)
    end

    class NullModel
      def self.from_queue_payload(_payload); NullModel.new; end

      def self.find_by(_hash); nil; end

      def save!; end

      def updated_at; nil; end
    end
  end
end
