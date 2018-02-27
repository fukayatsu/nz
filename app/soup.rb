require_relative 'life'

class Soup
  MAX_SIZE = 30000

  def initialize
    @map = Array.new(MAX_SIZE)
    @lives = [Life.create_origin(@map, at: MAX_SIZE/2)]
  end

  def lives_count
    @lives.size
  end

  def lives_summary
    summary = {}
    @lives.each do |life|
      summary[life.name] ||= 0
      summary[life.name] += 1
    end
    summary.map { |k, v| "#{k}: #{v}" }.join("\n")
  end

  def tick(step)
    step.times do |step|
      tick_one_step
      break if @lives.all?(&:error?)
    end
  end

  def tick_one_step
    daughters = []
    @lives.each do |life|
      next if life.error?
      daughter = life.tick
      if daughter
        daughters.push(daughter)
      end
    end
    @lives += daughters
  end
end
