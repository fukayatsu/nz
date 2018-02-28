module Instruction
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
end
