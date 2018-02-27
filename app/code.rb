class Code
  SEARCH_RANGE = 300
  INSTRUCTIONS = [
    # No Operations: 2
    :nop0,
    :nop1,

    # Memory Movement: 11
    :pushax, # (push AX onto stack)
    :pushbx, # (push BX onto stack)
    :pushcx, # (push CX onto stack)
    :pushdx, # (push DX onto stack)
    :popax,  # (pop from stack into AX)
    :popbx,  # (pop from stack into BX)
    :popcx,  # (pop from stack into CX)
    :popdx,  # (pop from stack into DX)
    :movcd,  # (DX = CX)
    :movab,  # (BX = AX)
    :movii,  # (move from ram [BX] to ram [AX])

    # Calculation: 9
    :sub_ab, # (CX = AX - BX)
    :sub_ac, # (AX = AX - CX)
    :inc_a,  # (increment AX)
    :inc_b,  # (increment BX)
    :inc_c,  # (increment CX)
    :dec_c,  # (decrement CX)
    :zero,   # (zero CX)
    :not0,   # (flip low order bit of CX)
    :shl,    # (shift left all bits of CX)

    # Instruction Pointer Manipulation: 5
    :ifz,  # (if CX == 0 execute next instruction, otherwise, skip it)
    :jmp,  # (jump to template)
    :jmpb, # (jump backwards to template)
    :call, # (push IP onto the stack, jump to template)
    :ret,  # (pop the stack into the IP)

    # Biological and Sensory: 5
    :adr,    #(search outward  for template, put address in AX, template size in CX)
    :adrb,   #(search backward for template, put address in AX, template size in CX)
    :adrf,   #(search forward  for template, put address in AX, template size in CX)
    :mal,    #(allocate amount of space specified in CX)
    :divide, #(cell division)

    # Total: 32 instructions
  ]

  attr_reader :opcode

  def initialize(instruction)
    @opcode =
      if instruction.is_a?(Symbol)
        INSTRUCTIONS.index(instruction)
      elsif 0 <= instruction && instruction <= 31
        instruction
      end

    unless @opcode
      raise "Invalid instruction: #{instruction}"
    end
  end

  def opname
    INSTRUCTIONS[opcode]
  end

  def apply(life)
    r = rand(2500)
    if r == 0
      life.ip += 1
      return
    elsif r == 1
      @opcode = rand(32)
    end

    case opname
    when :pushax
      life.stack.push life.ax
    when :pushbx
      life.stack.push life.bx
    when :pushcx
      life.stack.push life.cx
    when :pushdx
      life.stack.push life.dx
    when :popax
      life.ax = life.stack.pop
    when :popbx
      life.bx = life.stack.pop
    when :popcx
      life.cx = life.stack.pop
    when :popdx
      life.dx = life.stack.pop
    when :movcd
      life.dx = life.cx
    when :movab
      life.bx = life.ax
    when :movii # (move from ram [BX] to ram [AX])
      val = life.map[life.bx]

      r = rand(2500)
      if r == 0
        life.ip += 1
        return
      elsif r == 1
        val = rand(32)
      end

      # TODO: 書き込み権限確認
      life.map[life.ax] = val
    when :sub_ab
      life.cx = life.ax - life.bx
    when :sub_ac
      life.ax = life.ax - life.cx
    when :inc_a
      life.ax += 1
    when :inc_b
      life.bx += 1
    when :inc_c
      life.cx += 1
    when :dec_c
      life.cx -= 1
    when :zero
      life.cx = 0
    when :not0
      life.cx ^= 1
    when :shl
      life.cx <<= 1
    when :ifz
      life.ip += 1 unless life.cx.zero?
    when :jmp
      i = life.ip + 1
      template = find_template(life.map, i)
      offset = template_offset(life.map[i..i+SEARCH_RANGE], template)

      if offset
        return life.ip = i + offset + template.size
      else
        life.error!
      end
    when :call
      i = life.ip + 1
      template = find_template(life.map, i)
      offset = template_offset(life.map[i..i+SEARCH_RANGE], template)

      if offset
          life.stack.push life.ip
          life.ip = i + offset + template.size
        return
      else
        life.error!
      end
    when :jmpb
      i = life.ip + 1
      template = find_template(life.map, i)

      start = life.ip - SEARCH_RANGE
      start = 0 if start < 0
      offset = template_offset(life.map[start..life.ip].reverse, template.reverse)

      if offset
        return life.ip = i - offset
      else
        life.error!
      end
    when :ret
      life.ip = life.stack.pop
    when :adr
      i = life.ip + 1
      template = find_template(life.map, i)

      offset_f = template_offset(life.map[i..i+SEARCH_RANGE], template)

      start = life.ip - SEARCH_RANGE
      start = 0 if start < 0
      offset_b = template_offset(life.map[start..life.ip].reverse, template.reverse)


      if offset_f || offset_b
        offset_f ||= SEARCH_RANGE
        offset_b ||= SEARCH_RANGE
        if offset_f < offset_b
          life.ax = i + offset_f + template.size
        else
          life.ax = i - offset_b
        end
        life.cx = template.size
      else
        life.error!
      end
    when :adrf
      i = life.ip + 1
      template = find_template(life.map, i)
      offset = template_offset(life.map[i..i+SEARCH_RANGE], template)
      if offset
        life.ax = i + offset + template.size
        life.cx = template.size
      else
        life.error!
      end
    when :adrb
      i = life.ip + 1
      template = find_template(life.map, i)

      start = life.ip - SEARCH_RANGE
      start = 0 if start < 0
      offset = template_offset(life.map[start..life.ip].reverse, template.reverse)

      if offset
        life.ax = i - offset
        life.cx = template.size
      else
        life.error!
      end
    when :mal
      index = life.map.index.with_index do |_, i|
        life.map[i..(i + life.cx)].all?(&:nil?)
      end

      if index
        life.ax = index
        (index...(index+life.cx)).each do |i|
          life.map[i] = -1
        end
        life.daughter_range = index...(index+life.cx)
      else
        life.error!
      end
    when :divide
      daughter = Life.new(map: life.map, ip: life.daughter_range.first, gene: life.map[life.daughter_range])
      life.daughter_range = nil
      life.ip += 1
      life.error! unless life.range.include?(life.ip)
      return daughter
    end

    life.ip += 1
    life.error! unless life.range.include?(life.ip)
  end

  private

  def find_template(map, start)
    template = []
    i = 0
    loop do
      opcode = map[start + i]
      break unless opcode == 0 || opcode == 1

      template.push opcode^1
      i += 1
    end
    template
  end

  def template_offset(map, template)
    map.each_cons(template.size).with_index do |arr ,j|
      return j if arr == template
    end
    nil
  end
end
