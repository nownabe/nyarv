# frozen_string_literal: true

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
      @cfp = @lfp = @dfp = nil
      @instructions = InstructionsLoader.new(self)
    end

    def run
      loop do
        instruction = iseq[@pc]
        break unless instruction
        execute(instruction)
        @pc += 1 + instruction.operands.size
      end
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
      $stderr.puts "Execute\t#{instruction}"
      send(instruction.opecode, *instruction.operands)
      $stderr.puts "\t(Stack: #{stack[0...@sp].map(&:inspect).join(', ')})"
    rescue NoMethodError => e
      $stderr.puts "\t(Not implemented instruction '#{e.name}')"
    end

    # instructions

    def putself
      push scope
    end

    def putstring(string)
      push string
    end

    def opt_send_without_block(*args)
      method_name = args[0][:mid]
      argc = args[0][:orig_argc]
      args = Array.new(argc) { pop }
      receiver = pop
      push receiver.send(method_name, *args)
    end
  end
end
