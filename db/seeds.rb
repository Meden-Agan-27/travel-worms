# Here are the 4 methods for the scraping. Don't move them, they need to be before we call them.

def fetch_api_description(isbn)
  url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}"
  g_book_items = JSON.parse(open(url).read)['items']
  if !g_book_items.nil?
    g_book = g_book_items.first['volumeInfo']
    description = g_book['description'].nil? ? "" : g_book['description']
    image = g_book['imageLinks'].nil? ? "" : g_book['imageLinks']['thumbnail']
    results = {description: description, image: image}
  else
    results = {description: "", image: ""}
  end
end




def scrape_books(country)
  query = country.match?(/\s/) ? country.gsub("\s", "%20") : country
  query = country.match?(/\(([^)]+)\)/) ? country.gsub(/\(([^)]+)\)/, "").strip : country
  begin
    url = "https://www.goodreads.com/shelf/show/#{query}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    puts "open goodreads for #{country}"
    html_doc.search('.elementList').first(30).each do |book|
      title = book.search('a').attribute('title').value
      author = book.search('.authorName').text
      book_url = book.search('.bookTitle').attribute('href')
      puts "scraping for more info"
      results = scrape_one_book(book_url)
      Book.create(title: title, language: "english", country: country, author: author, image: results[:image], genre: "novel", description: results[:description], isbn: results[:isbn])
      puts "book created"
    end
   rescue URI::InvalidURIError
    puts "Invalid country"
  end
end

def scrape_one_book(book_url)
    url = "https://www.goodreads.com#{book_url}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    image = html_doc.search('#coverImage').attribute('src').nil? ? "" : html_doc.search('#coverImage').attribute('src').value
    isbn = html_doc.search('#description a:nth-child(1)').nil? ? html_doc.search('#description a:nth-child(1)').first.text : html_doc.search('.clearFloats:nth-child(2) .infoBoxRowItem').text.strip
      clean_isbn = isbn.match?(/\(([^)]+)\)/) ? isbn.gsub(/\(([^)]+)\)/, "").strip : isbn
      if clean_isbn.to_i != 0
        clean_isbn
      else
        clean_isbn = nil
      end
    puts "isbn: #{clean_isbn}"
    results = fetch_api_description(clean_isbn)
    image == "" ? {image: image, description: results[:description], isbn: clean_isbn} : {image: results[:image], description: results[:description], isbn: clean_isbn}
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

puts "Creating Profile"
Profile.new(first_name: "Madeline", last_name: "Andrean", about: "I like books", user: User.first ).save
Profile.new(first_name: "Gheorghe", last_name: "Tarcea", about: "I am always late", user: User.second).save

puts "Creating Bookshelves"
Bookshelf.new(name: "my_books", description: "This is your default bookshelf. Click on edit to make it fully yours", user: User.first).save
Bookshelf.new(name: "my_books", description: "This is your default bookshelf. Click on edit to make it fully yours", user: User.last).save
Bookshelf.new(name: "later", user: User.first).save
Bookshelf.new(name: "later", user: User.last).save
Bookshelf.new(name: "my_books", description: "This is your default bookshelf. Click on edit to make it fully yours", user: User.second).save
Bookshelf.new(name: "later", user: User.second).save

puts "Creating Bookshelf_items"
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.last).save!
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.first).save!
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.second).save!
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.last).save!
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.first).save!
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.second).save!
puts "Creating reviews"
books = Book.all
books.each do |book|
  Review.create(user: User.first, book: book, review_content: "This book was deceiving, I was expecting another kind of book...", rating: 1)
  Review.create(user: User.second, book: book, review_content: "I loved this book! You must read it. Now! I'm serious!", rating: 5)
  Review.create(user: User.find(3), book: book, review_content: "It was OK. You will learn a lot of things but it was a bit long. Chapter 6 is too boring, I haven't read it fully 😂", rating: 3)
  Review.create(user: User.last, book: book, review_content: "My mother-in-law offered me this book. It was interesting, but not really my cup of tea.", rating: 3)
end
puts "Seeding done..."
10.times { puts ">" }
puts "... Congratulations!"
