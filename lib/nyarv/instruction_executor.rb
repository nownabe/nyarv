# frozen_string_literal: true

module Nyarv
  class InstructionExecutor
    attr_reader :vm, :instruction

    def initialize(vm, instruction)
      @vm = vm
      @instruction = instruction
    end

    def execute
      $stderr.puts "Execute\t#{instruction}"
      instruction_proc = vm.instructions[instruction.opecode]

      unless instruction_proc
        $stderr.puts "\t(Not implemented instruction '#{instruction.opecode}')"
        return
      end

      instance_exec(*instruction.operands, &instruction_proc)
      print_stack
    end

    private

    def print_stack
      $stderr.puts "\t(Stack: #{vm.stack[0...vm.sp].map(&:inspect).join(', ')})"
    end

    # Helpers

    def get_self
      vm.get_self
    end

    def pop
      vm.pop
    end

    def push(val)
      vm.push(val)
    end
  end
end
