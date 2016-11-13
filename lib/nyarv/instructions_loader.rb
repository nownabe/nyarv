# frozen_string_literal: true

module Nyarv
  class InstructionsLoader
    attr_reader :vm

    def initialize
      @instructions = {}
    end

    def load(def_file = File.expand_path("../instructions.rb", __FILE__))
      instance_eval(File.read(def_file))
      @instructions
    end

    private

    def alias(alias_name, original_name)
      @instructions[alias_name] = @instructions[original_name]
    end

    def ins(name, &block)
      @instructions[name] = block
    end
  end
end
