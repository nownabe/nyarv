# frozen_string_literal: true

module Nyarv
  class VirtualMachine
    attr_reader :iseq, :scope, :stack

    def initialize(source)
      @iseq =
        case source
        when RubyVM::InstructionSequence
          source
        when !source.include?("\n") && File.exist?(File.expand_path(source))
          RubyVM::InstructionSequence.new(File.read(File.expand_path(argv[0])))
        when String
          RubyVM::InstructionSequence.new(source)
        end
      @stack = []
      @scope = Kernel
    end

    def run
      iseq.to_a.last.each do |instruction|
        next unless instruction.is_a?(Array)
        send(*instruction)
      end
    end

    private

    # instructions

    def trace(*arg)
      $stderr.puts "Not Implemented 'trace'"
    end

    def putself
      stack.push scope
    end

    def putstring(string)
      stack.push string
    end

    def opt_send_without_block(*args)
      method_name = args[0][:mid]
      argc = args[0][:orig_argc]
      args = argc.times.map { stack.pop }
      receiver = stack.pop
      stack.push receiver.send(method_name, *args)
    end

    def leave(*args)
      $stderr.puts "Not Implemented 'leave'"
    end
  end
end