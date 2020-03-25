class BookshelfItemsController < ApplicationController
  def index
    @bookshelf = Bookshelf.find(params[:id])
    @bookshelf_items = BookshelfItem.where(bookshelf_id: @bookshelf.id)
  end

  def show
    @bookshelf_item = BookshelfItem.find(params[:id])
  end

  def new
    @bookshelf_item = BookshelfItem.new
  end

  def destroy
    @bookshelf_item = BookshelfItem.find(params[:bookshelf_id])
    @bookshelf_item.destroy
    # raise
    redirect_to bookshelf_items_path
  end

end
