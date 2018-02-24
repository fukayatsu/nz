RSpec.configure do |config|
  Dir[File.join(File.dirname(__FILE__), '../src/**/*.rb')].each { |f| require f }
end
