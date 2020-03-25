class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @book = Book.find(params[:book_id])
    @review.book = @book
    @review.user = current_user
    if @review.save!
      redirect_to book_path(@book)
    else
      render "books/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :review_content)
  end
end
