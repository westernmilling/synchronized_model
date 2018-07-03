# frozen_string_literal: true
namespace :synchronized_model do
  desc 'Publish all records for a model'
  task :publish,
       %i(model_class_string touch_records) => :environment do |_t, args|
    logger = Logger.new(STDOUT)
    model_class = Module.const_get(args.model_class_string)

    logger.info "#{model_class.count} #{args.model_class_string} to publish"
    model_class.find_each do |model|
      if args.touch_records == 'true'
        logger.info "Touching UUID: #{model.try(:uuid)}, ID: #{model.id}"
        model.update(updated_at: Time.zone.now)
      end
      logger.info "Publishing UUID: #{model.try(:uuid)}, ID: #{model.id}"
      # This is not necessarily available.
      # I'm thinking we make this an endpoint and load circuitry in with
      # a config endpoint
      # detail in readme
      SynchronizedModel::Publish.new(model).call
      # PublishModelService.new(model).call
    end
  end
end
