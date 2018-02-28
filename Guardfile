guard "rspec", cmd: "bundle exec rspec" do
 require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  watch(%r(app/(.*?).rb)) do |file|
    "spec/#{file[1]}_spec.rb"
  end
end
