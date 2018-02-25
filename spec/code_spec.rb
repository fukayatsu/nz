RSpec.describe Code do
  describe '#new' do
    subject { described_class.new(instruction) }

    context ':nop0' do
      let(:instruction) { :nop0 }

      it do
        expect(subject.opcode).to eq(0)
        expect(subject.opname).to eq(:nop0)
      end
    end

    context ':nop1' do
      let(:instruction) { :nop1 }

      it do
        expect(subject.opcode).to eq(1)
        expect(subject.opname).to eq(:nop1)
      end
    end

    context '1' do
      let(:instruction) { 1 }

      it do
        expect(subject.opcode).to eq(1)
        expect(subject.opname).to eq(:nop1)
      end
    end
  end

  describe '#apply' do
    let(:instruction) { |ex| ex.metadata[:example_group][:description].to_sym }
    let(:code) { described_class.new(instruction) }
    let(:map)  { [] }
    let(:life) { Life.new(map: map, ip: 1) }

    subject(:applied) { code.apply(life); life }

    context 'No Operations: 2'  do
      context 'nop0' do
        it { expect(applied.ip).to eq 2 }
      end

      context 'nop1' do
        it { expect(applied.ip).to eq 2 }
      end
    end

    context 'Memory Movement: 11' do
      context 'pushax' do
        it do
          life.ax = 3
          code.apply(life)
          expect(life.stack).to eq [3]

          life.ax = 5
          code.apply(life)
          expect(life.stack).to eq [3, 5]
        end
      end

      context 'pushbx' do
        it do
          life.bx = 3
          code.apply(life)
          expect(life.stack).to eq [3]

          life.bx = 5
          code.apply(life)
          expect(life.stack).to eq [3, 5]
        end
      end

      context 'pushcx' do
        it do
          life.cx = 3
          code.apply(life)
          expect(life.stack).to eq [3]

          life.cx = 5
          code.apply(life)
          expect(life.stack).to eq [3, 5]
        end
      end

      context 'pushdx' do
        it do
          life.dx = 3
          code.apply(life)
          expect(life.stack).to eq [3]

          life.dx = 5
          code.apply(life)
          expect(life.stack).to eq [3, 5]
        end
      end

      context 'popax' do
        it do
          life.stack = [1, 2]
          code.apply(life)
          expect(life.stack).to eq [1]
          expect(life.ax).to eq 2
        end
      end

      context 'popbx' do
        it do
          life.stack = [1, 2]
          code.apply(life)
          expect(life.stack).to eq [1]
          expect(life.bx).to eq 2
        end
      end

      context 'popcx' do
        it do
          life.stack = [1, 2]
          code.apply(life)
          expect(life.stack).to eq [1]
          expect(life.cx).to eq 2
        end
      end

      context 'popdx' do
        it do
          life.stack = [1, 2]
          code.apply(life)
          expect(life.stack).to eq [1]
          expect(life.dx).to eq 2
        end
      end

      context 'movcd' do
        it do
          life.cx = 1
          expect(applied.dx).to eq 1
        end
      end

      context 'movab' do
        it do
          life.ax = 1
          expect(applied.bx).to eq 1
        end
      end

      # (move from ram [BX] to ram [AX])
      context 'movii' do
        let(:map)  { [1, 2, 3, 4] }
        it do
          life.ax = 1
          life.bx = 2
          expect(applied.map).to eq [1, 3, 3, 4]
        end
      end

      # Calculation: 9
      # :sub_ab, # (CX = AX - BX)
      context 'sub_ab' do
        it do
          life.ax = 7
          life.bx = 4
          expect(applied.cx).to eq 3
        end
      end

      # :sub_ac, # (AX = AX - CX)
      context 'sub_ac' do
        it do
          life.ax = 5
          life.cx = 2
          expect(applied.ax).to eq 3
        end
      end

      # :inc_a,  # (increment AX)
      context 'inc_a' do
        it do
          life.ax = 7
          expect(applied.ax).to eq 8
        end
      end

      # :inc_b,  # (increment BX)
      context 'inc_b' do
        it do
          life.bx = 3
          expect(applied.bx).to eq 4
        end
      end

      # :inc_c,  # (increment CX)
      context 'inc_c' do
        it do
          life.cx = 4
          expect(applied.cx).to eq 5
        end
      end

      # :dec_c,  # (decrement CX)
      context 'dec_c' do
        it do
          life.cx = 5
          expect(applied.cx).to eq 4
        end
      end

      # :zero,   # (zero CX)
      context 'zero' do
        it do
          expect(applied.cx).to eq 0
        end
      end

      # :not0,   # (flip low order bit of CX)
      context 'not0' do
        it do
          life.cx = 1
          code.apply(life)
          expect(life.cx).to eq 0

          life.cx = 5
          code.apply(life)
          expect(life.cx).to eq 4

          life.cx = 2
          code.apply(life)
          expect(life.cx).to eq 3
        end
      end

      # :shl,    # (shift left all bits of CX)
      context 'shl' do
        it do
          life.cx = 1
          code.apply(life)
          expect(life.cx).to eq 2

          code.apply(life)
          expect(life.cx).to eq 4

          code.apply(life)
          expect(life.cx).to eq 8
        end
      end

      # Instruction Pointer Manipulation: 5
      # :ifz,  # (if CX == 0 execute next instruction, otherwise, skip it)
      context 'ifz' do
        it do
          expect(life.ip).to eq(1)

          # zero
          life.cx = 0
          code.apply(life)
          expect(life.ip).to eq(2)

          # not zero
          life.cx = 1
          code.apply(life)
          expect(life.ip).to eq(4)
        end
      end

      # :jmp,  # (jump to template)
      context 'jmp' do
        let(:life) { Life.new(map: [-1, -1, 0, 1, 0, 0, -1, 1, 0, 1, 1, -1], ip: 1) }
        it do
          code.apply(life)
          expect(life.ip).to eq(life.map.size - 1)
        end
      end

      # :jmpb, # (jump backwards to template)
      context 'jmpb' do
        let(:life) { Life.new(map: [-1, 0, 1, 0, 0, -1, -1, -1, 1, 0, 1, 1, -1], ip: 8) }
        it do
          code.apply(life)
          expect(life.ip).to eq(5)
        end
      end

      # :call, # (push IP onto the stack, jump to template)
      context 'call' do
        let(:life) { Life.new(map: [-1, -1, 0, 0, 0, 0, -1, 1, 1, 1, 1, -1], ip: 1) }
        it do
          code.apply(life)
          expect(life.stack).to eq [1]
          expect(life.ip).to eq(life.map.size - 1)
        end
      end

      # :ret,  # (pop the stack into the IP)
      context 'ret' do
        let(:life) { Life.new(map: [], ip: 0) }
        it do
          life.stack = [9]
          code.apply(life)
          expect(life.stack).to eq []
          expect(life.ip).to eq(10)
        end
      end
    end
  end
end
