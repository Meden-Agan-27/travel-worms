class BookshelvesController < ApplicationController
  def index
    @bookshelves = current_user.bookshelves
  end
  # we don't need a show, when you click on a bookshelf, redirecting to bookshelf_items??
  def show
    @bookshelf = Bookshelf.find(params[:id])
    @bookshelf_items = BookshelfItem.where(bookshelf_id: @bookshelf.id)
  end

  def new
    @bookshelf = Bookshelf.new
    unless params[:book].nil?
      @book = Book.find(params[:book])
      @bookshelf.bookshelf_items.build
    end
  end

  def create
    @bookshelf = Bookshelf.new(bookshelf_params)
    @bookshelf.user = current_user

    if @bookshelf.save
      redirect_to bookshelves_path, notice: 'successfully created.'
    else
      render :new
    end
  end

  def edit
    @bookshelf = Bookshelf.find(params[:id])
  end

  def update
    @bookshelf = Bookshelf.find(params[:id])
    @bookshelf.update(bookshelf_params)
    redirect_to bookshelves_path, notice: 'update done'
  end

  def destroy
    @bookshelf = Bookshelf.find(params[:id])
    @bookshelf.destroy
    # raise
    redirect_to bookshelves_path
  end

  private
    def bookshelf_params
      params.require(:bookshelf).permit(:name, :description, bookshelf_items_attributes: [:book_id, :status, :book_shelf_id])
    end

end
