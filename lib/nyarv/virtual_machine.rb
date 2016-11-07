# frozen_string_literal: true

module Nyarv
  class VirtualMachine
    attr_reader :iseq, :scope, :stack

    def initialize(source)
      @iseq =
        if source.is_a?(RubyVM::InstructionSequence)
          source
        elsif !source.include?("\n") && File.exist?(source)
          RubyVM::InstructionSequence.compile_file(source)
        elsif source.is_a?(String)
          RubyVM::InstructionSequence.new(source)
        end
      @stack = []
      @scope = Kernel
    end

    def run
      iseq.to_a.last.each do |instruction|
        next unless instruction.is_a?(Array)
        execute(instruction)
      end
    end

    private

    def execute(instruction)
      $stderr.puts "Execute #{instruction}"
      send(*instruction)
      $stderr.puts "\tStack: #{stack}"
    rescue NoMethodError => e
      $stderr.puts "\tNot implemented instruction '#{e.name}'"
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
