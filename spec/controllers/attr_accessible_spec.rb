require 'spec_helper'

describe PostsController do

  xit 'should not raise error' do
    get :index

    expect(response).to be_success
  end

end
