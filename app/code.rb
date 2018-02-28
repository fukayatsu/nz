require_relative 'instruction'

class Code
  include Instruction

  def initialize(instruction)
    @id = parse_instruction(instruction)
  end
  attr_reader :id

  def name
    INSTRUCTIONS[id]
  end

  def apply(cell)
    case name
    when /push(.)x/
      cell.stack.push cell.send("#{$1}x")
    when /pop(.)x/
      cell.send("#{$1}x=", cell.stack.pop)
    when :movii
      # TODO
    when /mov(.)(.)/
      cell.send("#{$2}x=", cell.send("#{$1}x"))
    end
  end

  private

  def parse_instruction(instruction)
    if instruction.is_a?(Symbol)
      INSTRUCTIONS.index(instruction)
    elsif 0 <= instruction && instruction <= 31
      instruction
    else
      raise "Invalid instruction: #{instruction}"
    end
  end
end
