require 'spec_helper'
T34::Bomb.load('sample')

describe T34::Chain do
  let(:source) {
"class X
  def test_method(arg1, arg2)
  end
end"
  }

  let(:target) {
"class X
  def test_method
  end
end # X"
  }

  let(:chain) {
    T34::Chain.new(
      source,
      [Bombs::Sample::RemoveArgument, Bombs::Sample::RemoveArgument]
    )
  }

  it 'rewrite methods' do
    res = chain.reaction!
    expect(res).to eq target
  end

  it 'generates code back' do
    res = chain.reaction!
    expect(res).to eq target
  end


end
