# frozen_string_literal: true

require "nyarv/instruction_executor"

module Nyarv
  # https://github.com/ruby/ruby/blob/trunk/vm_core.h#L630
  class ControlFrame
    attr_reader :vm, :parent, :iseq, :self_, :block_code, :pc
    attr_accessor :sp, :ep

    def initialize(vm, parent, iseq, self_, block_code = nil)
      @vm = vm
      @parent = parent
      @iseq = iseq
      @self_ = self_
      @block_code = block_code
      @pc = 0
    end

    def run
      loop do
        instruction = iseq[@pc]
        break unless instruction
        execute(instruction)
        @pc += 1 + instruction.operands.size
      end
    end

    def dump_stack
      vm.dump_stack(@sp)
    end

    def get_self
      self_
    end

    def pop
      @sp -= 1
      vm.stack[@sp]
    end

    def push(val)
      vm.stack[@sp] = val
      @sp += 1
    end

    private

    def execute(instruction)
      InstructionExecutor.new(self, instruction).execute
    end
  end
end
