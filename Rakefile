
task default: :run

task :run do
  require './app/soup'

  soup = Soup.new

  100.times do
    soup.tick(1000)
    puts soup.lives_summary
    puts
  end

  puts soup.gene_bank_summary
end
