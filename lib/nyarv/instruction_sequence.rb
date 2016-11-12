# frozen_string_literal: true

require "forwardable"

require "nyarv/instruction"

module Nyarv
  # Wrapper
  class InstructionSequence
    extend Forwardable

    def self.from(source)
      if source.is_a?(RubyVM::InstructionSequence)
        new(source)
      elsif !source.include?("\n") && File.exist?(source)
        new(RubyVM::InstructionSequence.compile_file(source))
      elsif source.is_a?(String)
        new(RubyVM::InstructionSequence.new(source))
      end
    end

    attr_reader :ruby_iseq

    def initialize(ruby_iseq)
      @ruby_iseq = ruby_iseq.to_a
      @instruction_sequence = convert
    end

    def_delegator :@instruction_sequence, :[]

    private

    def body
      ruby_iseq.last
    end

    def convert
      line = nil
      address = 0
      body.each_with_object({}) do |instruction, seq|
        if instruction.is_a?(Array)
          seq[address] = Instruction.new(instruction, line)
          address += instruction.size
        else
          line = first_lineno + instruction - 1
        end
      end
    end

    def first_lineno
      ruby_iseq[8]
    end
  end
end
