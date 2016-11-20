# frozen_string_literal: true

module Nyarv
  class InstructionsLoader
    attr_reader :definition_file

    def initialize(definition_file)
      @definition_file = definition_file
    end

    def load
      @instructions = {}
      instance_eval(File.read(definition_file))
      @instructions
    end

    private

    def ins(name, &block)
      @instructions[name] = block
    end
  end
end
