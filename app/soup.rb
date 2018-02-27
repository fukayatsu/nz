require_relative 'life'

class Soup
  MAX_SIZE = 30000

  def initialize
    @map = Array.new(MAX_SIZE)
    @lives = [Life.create_origin(@map, at: MAX_SIZE/2)]
    @gene_bank = {  }
  end

  def gene_bank_summary
    @gene_bank
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
    @lives[0...1].each do |life|
      next if life.error?
      daughter = life.tick
      daughters.push(daughter) if daughter

      if life.division_count == 2 && @gene_bank[life.name].nil?
        @gene_bank[life.name] = life.gene
      end
    end
    @lives += daughters
  end
end
