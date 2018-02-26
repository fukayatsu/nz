
task default: :run

task :run do
  require './app/soup'

  soup = Soup.new
  soup.tick(800)
  require "pry"; binding.pry
end
