require_relative 'code'

class Life
  def initialize(map:, ip:, gene:)
    @map   = map
    @ip    = ip
    @gene  = gene

    @stack = []
    @error = false

    @range = ip...(ip+gene.size)
    @daughter_range = nil
  end
  attr_accessor :map, :ip, :ax, :bx, :cx, :dx, :stack
  attr_reader :gene, :range, :daughter_range

  def error?
    @error
  end

  def error!
    @error = true
  end

  def tick
    code = Code.new(map[ip])
    result = code.apply(self)
    if result.is_a? Life
      # NOTE: 増殖したとき
      result
    else
      nil
    end
  end

  def debug_print
    puts "ax: #{ax}\tbx: #{bx}\tcx: #{cx}\tdx: #{dx}"
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
