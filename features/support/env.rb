$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'hexarch2'

require 'spec/expectations'

include Hexarch2
Before do
  @app = App.new EventStorage.new
end
