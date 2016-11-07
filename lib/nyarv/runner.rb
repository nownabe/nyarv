# frozen_string_literal: true

require "nyarv/virtual_machine"

module Nyarv
  class Runner
    attr_reader :argv

    def initialize(argv = [])
      @argv = argv
    end

    def run
      VirtualMachine.new(argv[0]).run
    end
  end
end
