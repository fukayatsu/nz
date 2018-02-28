require_relative 'cell'

class World
  SOUP_SIZE = 30000

  def initialize
    @soup  = Array.new(SOUP_SIZE)
    @cells = [Cell.create_origin(soup: @soup, at: SOUP_SIZE/2)]
    @valid_genes = {}
  end

  def tick
    true # 1つ以上の生物がいる
  end

  def lives_summary
  end

  def gene_bank_summary
  end
end
