require 'digest/md5'

require_relative 'origin'
require_relative 'code'

class Cell
  def initialize(soup:, ip:, gene:)
    @soup  = soup
    @ip    = ip
    @gene  = gene
    @stack = []
    @range = ip...(ip+gene.size)
    @name  = "#{gene.size}-#{::Digest::MD5.hexdigest(@gene.join(','))}"

    @error = false
    @division_count = 0
  end
  attr_accessor :soup, :ip, :ax, :bx, :cx, :dx, :stack, :daughter_range
  attr_reader :gene, :range, :name, :division_count

  def error?
    @error
  end

  def error!
    @error = true
  end

  def can_write?(point)
    return true if @range.include?(point)
    return false unless @daughter_range
    @daughter_range.include?(point)
  end

  def tick
    code = Code.new(soup[ip])
    result = code.apply(self)
    if result.is_a? self.class
      result
    else
      nil
    end
  # rescue
  #   @error = true
  #   nil
  end

  def next_ip
    @ip += 1
  end

  def jump_ip(diff)
    @ip += diff
  end

  def check_ip_range!
    error! if @ip >= soup.size || @ip < 0
  end

  class << self
    include Origin

    def create_origin(soup, at: 0)
      gene = DEFAULT_GENE.map.with_index do |code, i|
        soup[at + i] = Code.new(code).id
      end
      new(soup: soup, ip: at, gene: gene)
    end
  end
end
