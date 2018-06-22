# frozen_string_literal: true

module SynchronizedModel
  module ReceiveMixin
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def synchronized_model_receive
        SynchronizedModel::ModelMessage.add_resource_class(self)
      end
    end
  end
end
