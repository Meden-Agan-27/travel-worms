# Here are the 3 methods for the scraping. Don't move them, they need to be before we call them.

def fetch_api_description(isbn)
  url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}"
  g_book_items = JSON.parse(open(url).read)['items']
  if !g_book_items.nil?
    g_book = g_book_items.first['volumeInfo']
    description = g_book['description'].nil? ? nil : g_book['description']
    puts "description: #{description}"
    image = g_book['imageLinks'].nil? ? nil : g_book['imageLinks']['thumbnail']
    if image.nil? || description.nil?
      results = nil
    else
      results = {description: description, image: image}
    end
  else
    results = nil
  end
end

def scrape_books(country)
  query = country.match?(/\s/) ? country.gsub("\s", "%20") : country
  query = country.match?(/\(([^)]+)\)/) ? country.gsub(/\(([^)]+)\)/, "").strip : country
  begin
    url = "https://www.goodreads.com/shelf/show/#{query}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    puts "Country: #{country}"
    html_doc.search('.elementList').first(30).each do |book|
      title = book.search('a').attribute('title').value
      author = book.search('.authorName').text
      book_url = book.search('.bookTitle').attribute('href')
      results = scrape_one_book(book_url)
      puts "results: #{results}"
      Book.create(title: title, language: "english", country: country, author: author, image: results[:image], genre: "novel", description: results[:description], isbn: results[:isbn]) if !results.nil?
    end
   rescue URI::InvalidURIError
    puts "Invalid country"
  end
end

def scrape_one_book(book_url)
    url = "https://www.goodreads.com#{book_url}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    image = html_doc.search('#coverImage').attribute('src').nil? ? nil : html_doc.search('#coverImage').attribute('src').value
    isbn = html_doc.search('#description a:nth-child(1)').nil? ? html_doc.search('#description a:nth-child(1)').first.text : html_doc.search('.clearFloats:nth-child(2) .infoBoxRowItem').text.strip
    puts "#{isbn}"
    clean_isbn = isbn.match?(/\(([^)]+)\)/) ? isbn.gsub(/\(([^)]+)\)/, "").strip : isbn
    puts "#{clean_isbn}"
    clean_isbn = nil if clean_isbn.to_i == 0
    puts "clean isbn: #{clean_isbn}"
    if !clean_isbn.nil?
      results = fetch_api_description(clean_isbn) if !clean_isbn.nil?
      results.nil? ? nil : {image: results[:image], description: results[:description], isbn: clean_isbn}
    else
      nil
    end
end

def scrape_countries

  url = "https://www.worldometers.info/geography/alphabetical-list-of-countries/"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  #for production, please remove the "first(5)"!
  html_doc.search('tr').first(2).each do |element|
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

scrape_books("afghanistan")
# scrape_countries
# adding a description with the books without one
books_without_description = Book.where(description: "")
books_without_description.each do |book|
  book.description = "This book is essential to the understanding of this country. It is a masterpiece. There are many interesting things to discover in it. Go ahead, go ahead, go ahead!"
  book.save
end
puts "Creating Users"
User.create(username: "maddy", password: "password", email: "maddy@book.com", preferred_language: "english")
User.create(username: "ghita", password: "password", email: "ghita@book.com", preferred_language: "english")
User.create(username: "marion1988", password: "password", email: "marion@gmail.com", preferred_language: "english")
User.create(username: "sano", password: "password", email: "sano@book.com", preferred_language: "english")
User.create(username: "rafiki", password: "password", email: "rafiki@book.com", preferred_language: "french")

puts "Creating Profile"
Profile.create(first_name: "Madeline", last_name: "Andrean", about: "I like books", user: User.first )
Profile.create(first_name: "Gheorghe", last_name: "Tarcea", about: "I am always late", user: User.second)
Profile.create(first_name: "Marion", last_name: "Bretonne", about: "About me", user: User.find(User.last.id - 2))

puts "Creating Bookshelves"
Bookshelf.create(name: "my_books", description: "This is your default bookshelf. Click on edit to make it fully yours", user: User.first)
Bookshelf.create(name: "my_books", description: "This is your default bookshelf. Click on edit to make it fully yours", user: User.last)
Bookshelf.create(name: "later", user: User.first)
Bookshelf.create(name: "later", user: User.last)
Bookshelf.create(name: "my_books", description: "This is your default bookshelf. Click on edit to make it fully yours", user: User.second)
Bookshelf.create(name: "later", user: User.second)

puts "Creating Bookshelf_items"
BookshelfItem.create(bookshelf: Bookshelf.first, book: Book.last)
BookshelfItem.create(bookshelf: Bookshelf.first, book: Book.first)
BookshelfItem.create(bookshelf: Bookshelf.first, book: Book.second)
BookshelfItem.create(bookshelf: Bookshelf.last, book: Book.last)
BookshelfItem.create(bookshelf: Bookshelf.last, book: Book.first)
BookshelfItem.create(bookshelf: Bookshelf.last, book: Book.second)
puts "Creating reviews"
books = Book.all
books.each do |book|
  if book.id.even?
    Review.create(user: User.first, book: book, review_content: "This book was deceiving, I was expecting another kind of book...", rating: 1)
    Review.create(user: User.second, book: book, review_content: "I loved this book! You must read it. Now! I'm serious!", rating: 5)
    Review.create(user: User.find(User.last.id - 1), book: book, review_content: "It was OK. You will learn a lot of things but it was a bit long. Chapter 6 is too boring, I haven't read it fully 😂", rating: 3)
    Review.create(user: User.last, book: book, review_content: "My mother-in-law offered me this book. It was interesting, but not really my cup of tea.", rating: 3)
  end
end
puts "Seeding done..."
10.times { puts ">" }
puts "... Congratulations!"
