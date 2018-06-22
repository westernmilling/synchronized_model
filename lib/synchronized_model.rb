# frozen_string_literal: true

require 'synchronized_model/version'

module SynchronizedModel
  autoload :MessageReceive, 'synchronized_model/message_receive'
  autoload :Message, 'synchronized_model/message'
  autoload :ModelMessage, 'synchronized_model/model_message'
  autoload :PublishMixin, 'synchronized_model/publish_mixin'
  autoload :ReceiveMixin, 'synchronized_model/receive_mixin'
  autoload :Support, 'synchronized_model/support'

  class << self
    attr_accessor :logger
    # ```ruby
    # SynchronizedModel.configure do |config|
    #   config.logger = Logger.new(STDOUT)
    # end
    # ```
    def configure
      yield self
      true
    end
  end
end
