# frozen_string_literal: true

require "nyarv/instructions_loader"

module Nyarv
  class Instructions
    class << self
      attr_accessor :definition_file

      def [](key)
        instructions[key]
      end

      def instructions
        @instructions ||=
          InstructionsLoader.new(@definition_file || default_definition_file).load
      end

      def default_definition_file
        File.expand_path("../instructions_definitions.rb", __FILE__)
      end
    end
  end
end
