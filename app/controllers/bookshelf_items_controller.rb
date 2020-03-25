class BookshelfItemsController < ApplicationController
  def index
    @bookshelf_items = BookshelfItem.all
  end

  def show
    # @bookshelf = Bookshelf.where(user_id: current_user.user_id)
    # @bookshelf_item = BookshelfItem.find(@bookshelf.id)
  end


end
