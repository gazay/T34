require 'spec_helper'

describe PostsController do

  it 'should not raise error' do
    get :index

    expect(response).to be_success
  end

end
