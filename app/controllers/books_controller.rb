require 'json'
require 'open-uri'

class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:search].present? && params[:search][:query].match(/^\w+$/)
      @query = true
      @user_input = params[:search][:query]
      @books = Book.search_by_country(@user_input)
      @books = @books.where(language:current_user.preferred_language) if current_user
    else
      @query = false
      if signed_in?
        @books = current_user.nil? ? @books = Book.all : Book.where(language: current_user.preferred_language)
      else
        @books = Book.all
      end
    end
  end

  def show
    @book = Book.find(params[:id])
    @review = Review.new
  end
end
