# Here are the 2 methods for the scraping. Don't move them, they need to be before we call them.
def scrape_books(country)
  query = country.match?(/\s/) ? country.gsub("\s", "%20") : country
  query = country.match?(/\(([^)]+)\)/) ? country.gsub(/\(([^)]+)\)/, "").strip : country
  begin
    url = "https://www.goodreads.com/shelf/show/#{query}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.elementList').first(30).each do |book|
      title = book.search('a').attribute('title').value
      author = book.search('.authorName').text
      image = book.search('img').attribute('src').value
      # Please add the image in the following line when the migration for adding image to book model would have been done.
      Book.create(title: title, language: "english", country: country, author: author)
    end
   rescue URI::InvalidURIError
    puts "Invalid country"
  end
end

def scrape_countries

  url = "https://www.worldometers.info/geography/alphabetical-list-of-countries/"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search('tr').first(5).each do |element|
    country = element.search('td:nth-child(2)').text.strip.downcase
      scrape_books(country)
      sleep(5)
  end
end


# Here is the actual seeding

puts "Cleaning DB"
User.destroy_all
Book.destroy_all

puts "Scraping and creating Books"
scrape_countries

puts "Creating Users"
User.new(username: "maddy", password: "password", email: "maddy@book.com", preferred_language: "english").save
User.new(username: "ghita", password: "password", email: "ghita@book.com", preferred_language: "english").save
User.new(username: "sano", password: "password", email: "sano@book.com", preferred_language: "english").save
User.new(username: "rafiki", password: "password", email: "rafiki@book.com", preferred_language: "french").save

puts "Creating Bookshelves"
Bookshelf.new(name: "my_books", user: User.first).save
Bookshelf.new(name: "my_books", user: User.last).save
Bookshelf.new(name: "later", user: User.first).save
Bookshelf.new(name: "later", user: User.last).save
Bookshelf.new(name: "my_books", user: User.second).save
Bookshelf.new(name: "later", user: User.second).save

puts "Creating Bookshelf_items"
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.last).save
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.first).save
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.second).save
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.last).save
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.first).save
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.second).save

puts "Creating reviews"
Review.new(user: User.first, book: Book.first, review_content: "I didn't like this book coz I can't read.", rating: 1).save
Review.new(user: User.second, book: Book.second, review_content: "I loved this book coz I can't read.", rating: 5).save
Review.new(user: User.second, book: Book.last, review_content: "It was OK.", rating: 3).save
Review.new(user: User.second, book: Book.first, review_content: "I hated this book coz I can read.", rating: 1).save
Review.new(user: User.last, book: Book.last, review_content: "Well, you know", rating: 3).save
puts "Seeding done..."
10.times { puts ">" }
puts "... Congratulations!"
