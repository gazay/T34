require 'spec_helper'
T34::Bomb.load('sample')

describe Bombs::Sample::RemoveArgument do
  let(:source) {
"class X
  def test_method(arg1, arg2)
  end
end"
  }

  let(:target) {
"class X
  def test_method(arg1)
  end
end # X"
  }

  let(:bomb) {
    Bombs::Sample::RemoveArgument.new source
  }

  it 'rewrite methods' do
    res = bomb.fire!
    expect(res.target).to eq target
  end

  it 'generates code back' do
    res = bomb.fire!
    expect(res.target).to eq target
  end

end
