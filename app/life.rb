require_relative 'code'

class Life
  def initialize(map:, ip:)
    @map   = map
    @ip    = ip
    @stack = []
    @error = false
  end
  attr_accessor :map, :ip, :ax, :bx, :cx, :dx, :stack

  def tick
    code = Code.new(map[ip])
    code.apply(self)
  end


  class << self
    def default_gene
      [
        :nop0, :nop0, :nop0, :nop0, # 母セル開始テンプレート
        :zero,
        :inc_c,
        :shl,
        :shl
      ]
    end

    def create_origin(map, at: 0)
      default_gene.each.with_index do |code, i|
        map[at + i] = Code.new(code).opcode
      end
      new(map: map, ip: at)
    end
  end
end
