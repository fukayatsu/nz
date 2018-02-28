RSpec.describe Code do
  describe '#apply' do
    let(:name) { |ex| ex.metadata[:example_group][:description].to_sym }
    let(:code) { described_class.new(name) }
    let(:soup) { [] }
    let(:gene) { [] }
    let(:ip)   { 0 }
    let(:cell) { Cell.new(soup: soup, ip: ip, gene: gene) }

    subject(:applied_cell) { code.apply(cell); cell }

    context 'nop0' do
      it do
        expect(applied_cell.ip).to eq 1
      end
    end

    context 'nop0' do
      it do
        expect(applied_cell.ip).to eq 1
      end
    end

    context 'pushax' do
      it do
        cell.ax = 1
        expect(applied_cell.stack).to eq [1]
      end
    end

    context 'popbx' do
      it do
        cell.stack.push 2
        expect(applied_cell.bx).to eq 2
        expect(cell.stack).to be_empty
      end
    end

    context 'popbx' do
      it do
        cell.stack.push 2
        expect(applied_cell.bx).to eq 2
        expect(cell.stack).to be_empty
      end
    end

    context 'movii' do
      let(:soup) { [10, 20, 30, 40, 50] }
      let(:gene) { soup }

      it 'move from ram [BX] to ram [AX]' do
        cell.ax = 1
        cell.bx = 3
        expect(applied_cell.error?).to eq false
        expect(cell.soup).to eq [10, 40, 30, 40, 50]
      end
    end

    context 'movab' do
      it do
        cell.ax = 1
        expect(applied_cell.bx).to eq 1
      end
    end

    context 'movcd' do
      it do
        cell.cx = 1
        expect(applied_cell.dx).to eq 1
      end
    end

    context 'jmp' do
      let(:name) { :jmp }
      let(:soup) { [0,1,2,3,  0,0,1,0,  8,9,10,11, 1,1,0,1,  16] }

      context 'forward' do
        let(:ip) { 3 }
        it do
          expect(applied_cell.ip).to eq(16)
        end
      end

      context 'backwards' do
        let(:name) { :jmpb }
        let(:ip) { 11 }
        it do
          expect(applied_cell.ip).to eq(8)
        end
      end


    end
  end
end
