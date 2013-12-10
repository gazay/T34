require 'spec_helper'

describe 'scopes transformation' do
  let(:test_file) {
    File.open(File.expand_path("../dummy/app/models/post.rb", __FILE__)) { |f| f.read }
  }

  xit 'raises if not a model given' do
    expect {
      T34.scopes('2 + 2')
    }.to raise_error
  end

  xit 'finds scopes' do
    res = T34.scopes(test_file)
    expect(res).to be_kind_of Array
    expect(res.map(&:class).compact).to eq [Parser::Source::Range]
    expect(res.map(&:source)).to eq [
      %q{scope :unnamed, where(title: nil)},
      %q{scope :named, where('title is not null')}
    ]
  end
end
