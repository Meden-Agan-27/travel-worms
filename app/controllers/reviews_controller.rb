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
      respond_to do |format|
        format.html { redirect_to book_path(@book) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'books/show' }
        format.js
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :review_content)
  end
end
