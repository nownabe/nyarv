# frozen_string_literal: true

module Nyarv
  class Instruction
    attr_reader :instruction, :opecode, :operands, :line

    def initialize(instruction, line)
      @instruction = instruction
      @opecode = instruction.first
      @operands = instruction[1..-1] || []
      @line = line
    end

    def to_s
      "#{opecode}\t#{operands.map(&:inspect).join(', ')}"
    end
  end
end
