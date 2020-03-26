class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if current_user
      @books = Book.where(language: current_user.preferred_language )
    else
      @books = Book.all
    end
  end

  def show
    @bookshelves = current_user.bookshelves
    # @bookshelves is needed for generating dropdown list with MyBookshelves
    @book = Book.find(params[:id])
    @review = Review.new
  end

end
