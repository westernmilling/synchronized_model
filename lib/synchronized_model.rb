# frozen_string_literal: true

require 'synchronized_model/version'
require 'synchronized_model/railtie' if defined?(Rails)

module SynchronizedModel
  autoload :MessageReceive, 'synchronized_model/message_receive'
  autoload :Message, 'synchronized_model/message'
  autoload :ModelMessage, 'synchronized_model/model_message'
  autoload :Publish, 'synchronized_model/publish'
  autoload :PublishMixin, 'synchronized_model/publish_mixin'
  autoload :Support, 'synchronized_model/support'

  class << self
    attr_accessor :logger, :publish_handler, :receive_resource_classes
    # ```ruby
    # SynchronizedModel.configure do |config|
    #   config.logger = Logger.new(STDOUT)
    #   config.publish_handler = proc do |message|
    #     Circuitry.publish("wm-otto-models", message)
    #   end
    #   config.receive_resource_classes =
    #    {
    #       'item': Item,
    #       'location': Location
    #    }
    # end
    # ```
    def configure
      yield self
      true
    end
  end
end
