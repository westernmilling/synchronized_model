# frozen_string_literal: true

require 'synchronized_model/version'

module SynchronizedModel
  autoload :Message, 'synchronized_model/message'
  autoload :PublishMixin, 'synchronized_model/publish_mixin'
  autoload :Support, 'synchronized_model/support'
end
