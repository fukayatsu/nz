require_relative 'cell'

class World
  SOUP_SIZE = 30000

  def initialize
    @soup  = Array.new(SOUP_SIZE)
    @cells = [Cell.create_origin(soup: @soup, at: SOUP_SIZE/2)]
    @valid_genes = {}
  end

  def tick
    next_tick = false
    daughters = []
    @cells.each do |cell|
      next if cell.error?

      daughter = cell.tick
      daughters.push(daughter) if daughter
      next_tick = true
    end
    @cells += daughters
    next_tick
  end

  def lives_summary
  end

  def gene_bank_summary
  end
end
