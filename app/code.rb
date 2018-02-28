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
      diff     = search_outward(cell, template)
      return cell.jump_ip(diff)
    when :jmpb
      template = find_template(cell)
      diff     = search_backward(cell, template)
      return cell.jump_ip(diff)
    when :call
      template = find_template(cell)
      diff     = search_outward(cell, template)
      cell.stack.push(cell.ip)
      return cell.jump_ip(diff)
    when :ret
      return cell.ret_ip
    when :adr
      template = find_template(cell, cx_size: true)
      diff     = search_outward(cell, template)
      cell.ax = cell.ip + diff
    when :adrb
      template = find_template(cell, cx_size: true)
      diff     = search_backward(cell, template)
      cell.ax = cell.ip + diff
    when :adrf
      template = find_template(cell, cx_size: true)
      diff     = search_forward(cell, template)
      cell.ax = cell.ip + diff
    when :mal
    when :divide
    end

    cell.next_ip
  end

  def find_template(cell, cx_size: false)
    template = cell.soup[cell.ip + 1, 10].take_while { |n| n == 0 || n == 1 }.map { |i| i ^= 1 }
    if cx_size
      template.take(cell.cx)
    else
      template
    end
  end

  def search_outward(cell, template)
    diff_f = search_forward(cell, template)
    diff_b = search_backward(cell, template)

    diff = [diff_f, diff_b].compact.min { |a, b| a.abs <=> b.abs }
  end

  def search_forward(cell, template)
    sub_soup = cell.soup[cell.ip + 1, SEARCH_RANGE]
    offset = sub_soup.index.with_index { |_, i| sub_soup[i, template.size] == template }
    return nil unless offset

    template.size + offset + 1
  end

  def search_backward(cell, template)
    start = cell.ip - SEARCH_RANGE
    start = 0 if start < 0

    sub_soup = cell.soup[start...cell.ip]
    offset   = sub_soup.rindex.with_index { |_, i| sub_soup[i, template.size] == template }
    return nil unless offset

    template.size - offset -  1
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
