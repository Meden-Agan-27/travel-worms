require 'json'
require 'open-uri'

class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:search].present? && params[:search][:query].match(/^\w+$/)
      @user_input = params[:search][:query]
      @books = Book.search_by_country(@user_input)
      @books = @books.where(language:current_user.preferred_language) if current_user
    # elsif !current_user
    #   @english_books = Book.where(language: "english" )
    # else
    #   if current_user.preferred_language != "english"
    #   @books = Book.where(language: current_user.preferred_language)
    #     if @books.empty?
    #       @english_books.each do |book|
    #         new_title = {fra_title: book[:fra_title], spa_title: book[:spa_title]}
    #         results = fetch_api(new_title)
    #         if !book.fra_title.nil?
    #         Book.create(title: book.fra_title, language: "french", country: book.country, author: book.author, image: results[:fra_results][:image], genre: "novel", original_title: book.original_title, description: results[:fra_results][:description])
    #         elsif !book.spa_title.nil?
    #         Book.create(title: book.spa_title, language: "spanish", country: book.country, author: book.author, image: results[:spa_results][:image], genre: "novel", original_title: book.original_title, description: results[:spa_results][:description])
    #         end
    #         end
        else
          @books = Book.where(language: current_user.preferred_language)
        end
    #   end
    # end
  end

  def show
    @book = Book.find(params[:id])
    @review = Review.new
  end

  private

# fetch_api({fra_title: "Le successeur kadare", spa_title: "El gran Gatsby"})
  def fetch_api(new_title)
    fra_title = new_title[:fra_title]
    # if !fra_title.nil?
      fra_query = fra_title.match?(/\s/) ? fra_title.gsub("\s", "+") : fra_title
      url = "https://www.googleapis.com/books/v1/volumes?q={#{fra_query}}&langRestrict={fr}"
      g_book = JSON.parse(open(url).read)['items'].first['volumeInfo']
      description = g_book['description'].nil? ? "" : g_book['description']
      image = g_book['imageLinks'].nil? ? "" : g_book['imageLinks']['thumbnail']
      fra_results = {description: description, image: image, language: "french"}
    # end
    spa_title = new_title[:spa_title]
    # if !spa_title.nil?
      spa_query = spa_title.match?(/\s/) ? spa_title.gsub("\s", "+") : spa_title
      url = "https://www.googleapis.com/books/v1/volumes?q={#{spa_query}}&langRestrict={se}"
      g_book = JSON.parse(open(url).read)['items'].first['volumeInfo']
      description = g_book['description'].nil? ? "" : g_book['description']
      image = g_book['imageLinks'].nil? ? "" : g_book['imageLinks']['thumbnail']
      spa_results = {description: description, image: image, language: "spanish"}
    # end
    results = {fra_results: fra_results, spa_results: spa_results}
    # check if book exists, create books from this info
  end
end
