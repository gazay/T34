require 'spec_helper'

describe T34::Rewriter::API::VariableNode do
  let(:source) {
    "a = 1"
  }

  let(:target) {
    "b = 1"
  }
  
  let(:rewriter) {
    T34::Rewriter.new(source)
  }

  it 'finds variables', :focus do
    expect(rewriter.variables).to be_kind_of Array
    expect(rewriter.variables.map(&:class)).to eq [T34::Rewriter::API::VariableNode]
    expect(rewriter.variables[0].name).to eq 'a'
  end

  it 'manipulates variables' do
    rewriter.variables do |variable|
      variable.name = 'b'
    end
    expect(rewriter.target).to eq target
  end
end
