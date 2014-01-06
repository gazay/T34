require 'spec_helper'

describe 't34' do

  SOURCE = \
"class X
  def test_method(arg1, arg2)
  end
end"

  TARGET = \
"class X
  def test_method(arg1)
  end
end"

  describe 'methods' do
    before :each do
      @rewriter = T34::Rewriter.new(SOURCE)
    end

    it 'can find all method_names in source code' do
      expect(@rewriter.source.method_names).to include(:test_method)
    end

    it 'can find all method args' do
      expect(@rewriter.source.methods[:test_method].arg_names).to eq [:arg1, :arg2]
    end

  end
end
