class BookshelfItemsController < ApplicationController
  def index
    @bookshelf = Bookshelf.find(params[:id])
    @bookshelf_items = BookshelfItem.where(bookshelf_id: @bookshelf.id)
  end

  def show
    # @bookshelf_item = BookshelfItem.find(params[:id])
  end

  def new
    @bookshelf_item = BookshelfItem.new
  end

  def create
    @book = Book.find(params[:book_id])
    @bookshelf = Bookshelf.find(params[:bookshelf_id])
    @bookshelf_item = BookshelfItem.new(book: @book, bookshelf: @bookshelf)
    @bookshelf_item.book_id = @book.id
    if @bookshelf_item.save
      redirect_to bookshelves_path, notice: 'successfully created.'
    else
      render :new
    end
  end

  def update
    @bookshelf_item = BookshelfItem.find(params[:bookshelf_id])
    @bookshelf_item.update(bookshelf_params)
    redirect_to bookshelves_path, notice: 'update done'
  end

  def destroy
    @bookshelf_item = BookshelfItem.find(params[:bookshelf_id])
    @bookshelf_item.destroy
    # raise
    redirect_to bookshelf_path
  end

  # private
  #   def bookshelf_item_params
  #     params.require(:bookshelf_item).permit(:status)
  #   end

end
