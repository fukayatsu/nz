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
      if cell.can_write?(cell.ax)
        cell.soup[cell.ax] = cell.soup[cell.bx]
      else
        cell.error!
      end
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
    when :jmp
      template = find_template(cell)
      distance = search_forward(cell, template)
      return cell.jump_ip(cell.ip + distance)
    when :jmpb
      template = find_template(cell)
      distance = search_backward(cell, template)
      return cell.jump_ip(cell.ip - distance)
    end

    cell.next_ip
  end

  def find_template(cell)
    cell.soup[cell.ip + 1, 10].take_while { |n| n == 0 || n == 1 }.map { |i| i ^= 1 }
  end

  def search_forward(cell, template)
    sub_soup = cell.soup[cell.ip + 1, SEARCH_RANGE]
    offset = sub_soup.index.with_index { |_, i| sub_soup[i, 4] == template }
    return nil unless offset

    offset + template.size + 1
  end

  def search_backward(cell, template)
    start = cell.ip - SEARCH_RANGE
    start = 0 if start < 0

    sub_soup = cell.soup[start...cell.ip]
    offset   = sub_soup.rindex.with_index { |_, i| sub_soup[i, 4] == template }
    return nil unless offset

    offset - template.size + 1
  end

  private

  def parse_instruction(instruction)
    if instruction.is_a?(Symbol)
      INSTRUCTIONS.index(instruction)
    elsif instruction.ia_a?(Integer) && 0 <= instruction && instruction <= 31
      instruction
    else
      raise "Invalid instruction: #{instruction}"
    end
  end
end
