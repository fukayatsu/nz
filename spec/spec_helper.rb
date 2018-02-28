RSpec.configure do |config|
  Dir[File.join(File.dirname(__FILE__), '../app/**/*.rb')].each { |f| require f }
end
