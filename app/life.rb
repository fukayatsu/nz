require_relative 'code'

class Life
  def initialize(map:, ip:, gene:)
    @map   = map
    @ip    = ip
    @gene  = gene

    @stack = []
    @error = false
  end
  attr_accessor :map, :ip, :ax, :bx, :cx, :dx, :stack
  attr_reader :gene

  def tick
    code = Code.new(map[ip])
    code.apply(self)
    nil # TODO devide時はnew lifeを返す
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
      gene = default_gene.map.with_index do |code, i|
        map[at + i] = Code.new(code).opcode
      end
      new(map: map, ip: at, gene: gene)
    end
  end
end
