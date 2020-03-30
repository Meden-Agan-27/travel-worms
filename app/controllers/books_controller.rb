require 'json'
require 'open-uri'


# class BooksController < ApplicationController
#   skip_before_action :authenticate_user!, only: [:index, :show]

#   def index
#     if current_user
#       @books = Book.where(language: current_user.preferred_language )
#     else
#       @books = Book.all
#     end
#   end

#   def show
#     @book = Book.find(params[:id])
#     @review = Review.new
#   end

  # private

  def fetch_api(fra_title)
    # get api key
    # API_KEY
    # store key .env
    # make API call with title from books (@books + current_user.preferred_language
    # query = "Le successeur"

    query = fra_title.match?(/\s/) ? fra_title.gsub("\s", "+") : fra_title
    url = "https://www.googleapis.com/books/v1/volumes?q={#{query}}&langRestrict={fr}"
    g_book = JSON.parse(open(url).read)['items'].first['volumeInfo']

    description = g_book['description'].nil? ? "" : g_book['description']
    image = g_book['imageLinks'].nil? ? "" : g_book['imageLinks']['thumbnail']

    p results = {description: description, image: image}




    # check if book exists, create books from this info
  end
# end
fetch_api("Le successeur kadare")
