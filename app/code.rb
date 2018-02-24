class Code
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
      else
        instruction
      end
  end

  def opname
    INSTRUCTIONS[opcode]
  end

  def apply(life)
    life.ip += 1

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
      # TODO: 書き込み権限確認
      life.map[life.ax] = life.map[life.bx]
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
    end
  end
end
