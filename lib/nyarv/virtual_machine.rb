# frozen_string_literal: true

require "nyarv/instruction_sequence"

module Nyarv
  class VirtualMachine
    attr_reader :iseq, :scope, :stack

    def initialize(source)
      @iseq = InstructionSequence.from(source)
      @stack = []
      @scope = Kernel
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

    private

    def execute(instruction)
      $stderr.puts "Execute\t#{instruction}"
      send(instruction.opecode, *instruction.operands)
      $stderr.puts "\t(Stack: #{stack.map(&:inspect).join(', ')})"
    rescue NoMethodError => e
      $stderr.puts "\t(Not implemented instruction '#{e.name}')"
    end

    # instructions

    def putself
      stack.push scope
    end

    def putstring(string)
      stack.push string
    end

    def opt_send_without_block(*args)
      method_name = args[0][:mid]
      argc = args[0][:orig_argc]
      args = Array.new(argc) { stack.pop }
      receiver = stack.pop
      stack.push receiver.send(method_name, *args)
    end
  end
end
