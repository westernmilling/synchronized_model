# frozen_string_literal: true

module SynchronizedModel
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/publish.rake'
    end
  end
end
