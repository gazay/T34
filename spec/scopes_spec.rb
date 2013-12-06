require 'spec_helper'

describe 'scopes transformation' do
  let(:test_file) {
    File.open(File.expand_path("../dummy/app/models/post.rb", __FILE__)) { |f| f.read }
  }

  it 'finds scopes' do
    expect(T34.scopes(test_file)).to eq nil
  end
end
