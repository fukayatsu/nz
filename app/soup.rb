require_relative 'life'

class Soup
  MAX_SIZE = 100

  def initialize
    @map = Array.new(MAX_SIZE)
    @lives = [Life.create_origin(@map, at: MAX_SIZE/2)]
  end

  def lives_count
    @lives.size
  end

  def tick(step)
    step.times do
      tick_one_step

      break if @lives.all?(&:error?)
    end
  end

  def tick_one_step
    daughters = []
    @lives.each do |life|
      life.debug_print
      next if life.error?
      daughter = life.tick
      daughters.push(daughter) if daughter
    end
    @lives += daughters
  end
end
