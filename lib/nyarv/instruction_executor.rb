# frozen_string_literal: true

require "nyarv/instructions"
require "forwardable"

module Nyarv
  class InstructionExecutor
    extend Forwardable

    attr_reader :control_frame, :instruction

    def initialize(control_frame, instruction)
      @control_frame = control_frame
      @instruction = instruction
    end

    def execute
      $stderr.puts "Execute\t#{instruction}"
      instruction_proc = Instructions[instruction.opecode]

      unless instruction_proc
        $stderr.puts "\t(Not implemented instruction '#{instruction.opecode}')"
        return
      end

      instance_exec(*instruction.operands, &instruction_proc)
      control_frame.dump_stack
    end

    private

    def method_missing(name, *args)
      if control_frame.respond_to?(name)
        control_frame.send(name, *args)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      control_frame.respond_to?(name) || super
    end
  end
end
