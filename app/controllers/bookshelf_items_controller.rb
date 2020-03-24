class BookshelfItemsController < ApplicationController
  def show
    raise
    @bookshelf_item = BookshelfItem.find(@bookshelf.id)
  end
end
