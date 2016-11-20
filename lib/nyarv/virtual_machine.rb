# frozen_string_literal: true

require "nyarv/instruction_executor"
require "nyarv/instruction_sequence"
require "nyarv/instructions_loader"

module Nyarv
  class VirtualMachine
    attr_reader :iseq, :scope, :stack
    attr_reader :pc, :sp, :cfp, :lfp, :dfp

    def initialize(source)
      @iseq = InstructionSequence.from(source)
      @stack = []
      @scope = Kernel
      @pc = @sp = 0
    end

    def run
      loop do
        instruction = iseq[@pc]
        break unless instruction
        execute(instruction)
        @pc += 1 + instruction.operands.size
      end
    end

    def get_self
      scope
    end

    def pop
      @sp -= 1
      stack[@sp]
    end

    def push(val)
      stack[@sp] = val
      @sp += 1
    end

    private

    def execute(instruction)
      InstructionExecutor.new(self, instruction).execute
    end
  end
end
