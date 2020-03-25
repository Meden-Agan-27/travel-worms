class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @book = Book.find(params[:book_id])
    @review.book = @book
    if @review.save
      redirect_to book_path(@book)
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :review_content)
  end
end
