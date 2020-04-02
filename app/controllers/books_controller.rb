class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:search].present? && params[:search][:query].match(/^\w+$/)
      @query = true
      @user_input = params[:search][:query]
      @books = Book.search_by_country(@user_input)
      @books = @books.where(language:current_user.preferred_language) if current_user
    else
      @books = Book.all
      @query = false
    end
  end

  def show
    @book = Book.find(params[:id])
    @review = Review.new
  end
end
