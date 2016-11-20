# frozen_string_literal: true

require "nyarv/control_frame"
require "nyarv/instruction_sequence"

module Nyarv
  class VirtualMachine
    attr_reader :iseq, :stack

    def initialize(source)
      @iseq = InstructionSequence.from(source)
      @stack = []
    end

    def run
      cf = ControlFrame.new(
        self,
        nil,
        iseq,
        main,
        nil
      )
      cf.sp = 0
      cf.ep = 0
      cf.run
    end

    def dump_stack(sp)
      $stderr.puts "\t(Stack: #{stack[0...sp].map(&:inspect).join(', ')})"
    end

    private

    def main
      Object.new
    end
  end
end
