
task default: :run

task :run do
  require './app/world'

  world = World.new

  10000.times do |i|
    unless next_tick = world.tick
      puts "...World end..."
      break
    end

    # if i % 1000 == 0
    puts "step: #{i}"
    # puts world.lives_summary
    puts
    # end
  end

  puts world.gene_bank_summary
end
