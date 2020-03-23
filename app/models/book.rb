class Book < ApplicationRecord
  validates_presence_of :title, :language, :genre
end
