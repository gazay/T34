
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
    expect(rewriter.blocks.map(&:class)).to eq [T34::Rewriter::API::BlockNode]
    expect(rewriter.blocks[0].children.map(&:class)).to eq [T34::Rewriter::API::ArgsNode, T34::Rewriter::API::SendNode]
  end

  it 'finds no blocks' do
    rewriter = T34::Rewriter.new(source_without_block)
    expect(rewriter.blocks).to be_kind_of Array
    expect(rewriter.blocks).to eq []
  end
end
