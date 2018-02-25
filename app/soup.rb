require_relative 'life'

class Soup
  MAX_SIZE = 200

  def initialize
    @map = Array.new(MAX_SIZE)
    @lives = [Life.create_origin(@map, at: MAX_SIZE/2)]
  end

  def lives_count
    @lives.size
  end

  def tick(step)
    step.times do |step|
      puts "[debug] step: #{step}"
      tick_one_step
      break if @lives.all?(&:error?)
    end
  end

  def tick_one_step
    daughters = []
    @lives.each do |life|
      next if life.error?
      daughter = life.tick
      life.debug_print
      if daughter
        require "pry"; binding.pry
        puts "new life"
        daughters.push(daughter)
      end
    end
    @lives += daughters
  end
end
