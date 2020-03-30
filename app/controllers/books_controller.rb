class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
      if params[:search].present? && params[:search][:query].match(/^\w+$/)
        @user_input = params[:search][:query]
        @books = Book.search_by_country(@user_input)
        @books = @books.where(language:current_user.preferred_language) if current_user
      else
      @books = Book.all
    end
  end

  def show
    @book = Book.find(params[:id])
    @review = Review.new
  end

  # def index
  #   if params[:search].present? && params[:search][:query].match(/^\d+$/)
  #     user_input = params[:search][:query]
  #     @movies = Movie.where(year: user_input)
  #   elsif params[:search].present?
  #     user_input = params[:search][:query]
  #     @movies_pg_format = PgSearch.multisearch(user_input)
  #     @movies = @movies_pg_format.map(&:searchable)
  #   else
  #     @movies = Movie.all
  #   end
  # end

end
