require_relative 'life'

class Soup
  DEFAULT_SIZE = 1000

  def initialize(size: DEFAULT_SIZE)
    @map = Array.new(size, -1)
    @lives = [Life.create_origin(@map, at: size/2)]
  end

  def lives_count
    @lives.size
  end

  def tick(step)
    step.times { tick_one_step }
  end

  def tick_one_step
    daughters = @lives.map { |life| life.tick }.compact
    @lives += daughters
  end
end
