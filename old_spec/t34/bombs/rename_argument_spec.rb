require 'spec_helper'
T34::Bomb.load('sample')

describe Bombs::Sample::RenameArgument do

  before(:each) do
    @source = \
"class X
  def test_method(arg1)
  end
end"

    @target = \
"class X
  def test_method(xxx)
  end
end # X"

    @bomb = Bombs::Sample::RenameArgument.new @source
  end

  it 'rewrites args name' do
    @bomb.rename_from = 'arg1'
    @bomb.rename_to = 'xxx'
    res = @bomb.fire!
    expect(res.target).to eq @target
  end

  it 'rewrites args name if args optional' do
    @source = @source.gsub('arg1', 'arg1 = 1')
    @target = @target.gsub('xxx', 'xxx = 1')
    @bomb = Bombs::Sample::RenameArgument.new @source
    @bomb.rename_from = 'arg1'
    @bomb.rename_to = 'xxx'
    res = @bomb.fire!
    expect(res.target).to eq @target
  end

end
