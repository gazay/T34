require 'pry-debugger' rescue nil

$:.push File.expand_path("../../lib", __FILE__)
require 't34'

RSpec.configure do |config|
  config.order = "random"
end
