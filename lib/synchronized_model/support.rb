# frozen_string_literal: true
module SynchronizedModel
  module Support
    # Taken from ActiveSupport:Inflector.underscore
    def underscore(camel_cased_word)
      return camel_cased_word unless matches_wrapper(camel_cased_word)
      word = camel_cased_word.to_s.gsub('::', '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word
    end

    private

    # `match?` was added in Ruby 2.4 this allows us to be backwards
    # compatible with older Ruby versions
    def matches(word)
      if regexp.respond_to?(:match?)
        regexp.match?(word)
      else
        regexp.match(word)
      end
    end

    def camel_case_regexp
      /[A-Z-]|::/
    end
  end
end
