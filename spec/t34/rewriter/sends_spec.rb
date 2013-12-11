require 'spec_helper'

describe T34::Rewriter::API::SendNode do
  let(:source) {
"scope :sample, where(id: 1)"
  }

  let(:target) {
"scope(:sample, lambda do\n  where({:id => 1})\nend)"
  }

  let(:target2) {
"new_name :sample, where(id: 1) "
  }

  let(:target3) {
"scope :sample, new_name(id: 1) "
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

  it 'manipulates sends values of send' do
    res = rewriter.sends(:scope) do |send_node|
      send_node.sends(:where) do |inner_send|
        inner_send.method_name = :new_name
      end
    end
    expect(res[0].arg_values[1].children[1]).to eq :new_name
  end

  it 'wraps inner sends with lambda' do
    rewriter.rewrite do
      sends(:scope) do |send_node|
        where_node = send_node.sends(:where).first
        send_node.replace where_node, where_node.wrap_with_lambda
      end
    end
    expect(rewriter.target).to eq target
  end

end
