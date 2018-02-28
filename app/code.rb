require_relative 'instruction'

class Code
  include Instruction

  def initialize(instruction)
    @id = parse_instruction(instruction)
  end

  attr_reader :id

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
