require 'spec_helper'

describe T34::Rewriter::API::SendNode do
  let(:source) {
"scope :sample, where(id: 1)"
  }

  let(:target) {
"scope :sample, -> { where(id: 1) }"
  }

  let(:target2) {
"new_name :sample, where(id: 1) "
  }

  let(:rewriter) {
    T34::Rewriter.new source
  }

  it 'finds sends' do
    expect(rewriter.sends(:scope)).to be_kind_of Array
  end

  it 'finds sends nodes' do
    expect(rewriter.sends(:scope).map(&:class).compact).to eq [T34::Rewriter::API::SendNode]
  end

  it 'manipulates sends' do
    res = rewriter.sends(:scope) do |send_node|
      send_node.method_name = :new_name
    end
    expect(res[0].method_name).to eq :new_name
  end

end
