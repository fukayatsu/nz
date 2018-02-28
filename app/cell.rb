require_relative 'origin'
require_relative 'code'

class Cell
  def initialize(soup:, ip:, gene:)
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
