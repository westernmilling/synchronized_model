# frozen_string_literal: true

require 'synchronized_model/version'

module SynchronizedModel
  autoload :MessageReceive, 'synchronized_model/message_receive'
  autoload :Message, 'synchronized_model/message'
  autoload :ModelMessage, 'synchronized_model/model_message'
  autoload :PublishMixin, 'synchronized_model/publish_mixin'
  autoload :Support, 'synchronized_model/support'

  class << self
    attr_accessor :logger, :receive_resource_classes
    # ```ruby
    # SynchronizedModel.configure do |config|
    #   config.logger = Logger.new(STDOUT)
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
