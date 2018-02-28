require_relative 'instruction'

class Code
  SEARCH_RANGE = 1000
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
    when :sub_ab
      cell.cx = cell.ax - cell.bx
    when :sub_ac
      cell.ax = cell.ax - cell.cx
    when /inc_(.)/
      cell.send("#{$1}x+=", 1)
    when /dec_(.)/
      cell.send("#{$1}x-=", 1)
    when :zero
      cell.cx = 0
    when :not0
      cell.cx ^= 1
    when :shl
      cell.cx <<= 1
    when :ifz
      cell.ip += 1 unless cell.cx.zero?

    end

    cell.next_ip
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
