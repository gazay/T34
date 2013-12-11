
require 'spec_helper'

describe T34::Rewriter::API::BlockNode do
  let(:source_with_block) {
"test_method :arg do
  other_method
end
"
  }

  let(:source_without_block) {
    "test_method :arg, other_method"
  }

  it 'finds blocks' do
    rewriter = T34::Rewriter.new(source_with_block)
    expect(rewriter.blocks).to be_kind_of Array
    expect(rewriter.blocks).to eq nil #[T34::Rewriter::API::BlockNode]
  end

  xit 'finds no blocks' do
    rewriter = T34::Rewriter.new(source_without_block)
    expect(rewriter.blocks).to be_kind_of Array
    expect(rewriter.blocks).to eq []
  end
end
