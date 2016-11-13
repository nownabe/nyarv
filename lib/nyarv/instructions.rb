# frozen_string_literal: true

# define instruction:
#
#   ins :instruction_name do |operand1, operand2, ...|
#     instruction_body
#   end
#
# define alias:
#
#   alias :opt_send_without_block, :send
#
# helpers:
#   - push val
#   - pop

## block.arity

ins :putself do
  push get_self
end

ins :putstring do |string|
  push string
end

ins :opt_send_without_block do |info, cache|
  method_name = info[:mid]
  args = Array.new(info[:orig_argc]) { pop }
  receiver = pop
  push receiver.send(method_name, *args)
end
