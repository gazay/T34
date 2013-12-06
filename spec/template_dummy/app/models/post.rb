class Post < ActiveRecord::Base

  attr_accessible :title
  scope :unnamed, where(title: nil)
  scope :named, where('title is not null')
end
