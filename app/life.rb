require 'digest/md5'
require_relative 'code'

class Life
  def initialize(map:, ip:, gene:)
    @map   = map
    @ip    = ip
    @gene  = gene
    @name  = "#{gene.size}-#{::Digest::MD5.hexdigest(@gene.join(','))}"
    @stack = []
    @error = false

    @range = ip...(ip+gene.size)
    @division_count = 0
  end
  attr_accessor :map, :ip, :ax, :bx, :cx, :dx, :stack, :daughter_range
  attr_reader :gene, :range, :name, :division_count

  def division!
    @division_count += 1
  end

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
  rescue => e
    error!
    nil
  end

  class << self
    def default_gene
      [
        :nop1, :nop1, :nop1, :nop1, # 母セルコード開始テンプレート
          :adrb, :nop0, :nop0, :nop0, :nop0, # 母セルコード開始テンプレートと相補
          :sub_ac,
          :movab,
          :movcd,
          :adrf, :nop0, :nop0, :nop0, :nop1, # コード終了テンプレートと相補
          :inc_a,
          :sub_ab, # 母セルのコードサイズをCXに保存
          :nop0, :nop0, :nop1, :nop0, # 自己複製ループのアドレステンプレート
            :mal,
            :call, :nop0, :nop0, :nop1, :nop1, # コピープロシージャ
            :divide,
            :jmpb, :nop1, :nop1, :nop0, :nop1, # 自己複製ループのアドレステンプレート
          :ifz, # ダミー
          :nop1, :nop1, :nop0, :nop0, # コピープロシージャ開始
            :pushax,
            :pushbx,
            :pushcx,
            :nop1, :nop0, :nop1, :nop0, # コピーループ開始
              :movii,
              :dec_c,
              :ifz,
                :jmp, :nop0, :nop1, :nop0, :nop0, # コピープロシージャ終了へ
              :inc_a,
              :inc_b,
              :jmpb, :nop0, :nop1, :nop0, :nop1, # コピーループ続行
          :ifz, # ダミー
          :nop1, :nop0, :nop1, :nop1, # コピープロシージャ終了
          :popcx,
          :popbx,
          :popax,
          :ret,
        :nop1, :nop1, :nop1, :nop0, # コード終了テンプレート
        :ifz # ダミー
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
