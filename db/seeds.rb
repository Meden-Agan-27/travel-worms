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


# Calling GoogleBooks API in order to create French and Spanish books
def fetch_api(new_title)
  # fetching info for the french book
  fra_title = new_title[:fra_title]
  if !fra_title.nil?
    fra_query = fra_title.match?(/\s/) ? fra_title.gsub("\s", "+") : fra_title
    url = "https://www.googleapis.com/books/v1/volumes?q={#{fra_query}}&langRestrict={fr}"
    g_book = JSON.parse(open(url).read)['items'].first['volumeInfo']
    description = g_book['description'].nil? ? "" : g_book['description']
    image = g_book['imageLinks'].nil? ? "" : g_book['imageLinks']['thumbnail']
    fra_results = {description: description, image: image, language: "french"}
  else
    fra_results = {description: nil, image: nil, language: "french"}
  end

  # fetching info for the french book
  spa_title = new_title[:spa_title]
  if !spa_title.nil?
    spa_query = spa_title.match?(/\s/) ? spa_title.gsub("\s", "+") : spa_title
    url = "https://www.googleapis.com/books/v1/volumes?q={#{spa_query}}&langRestrict={se}"
    g_book = JSON.parse(open(url).read)['items'].first['volumeInfo']
    description = g_book['description'].nil? ? "" : g_book['description']
    image = g_book['imageLinks'].nil? ? "" : g_book['imageLinks']['thumbnail']
    spa_results = {description: description, image: image, language: "spanish"}
  else
    spa_results = {description: nil, image: nil, language: "spanish"}
  end
    results = {fra_results: fra_results, spa_results: spa_results}
end


# Scraping UNESCO
def get_alternative_titles(original_title)
    languages = ["fra", "spa"]
    result = {}
    query = original_title.match?(/\s/) ? original_title.gsub("\s", "+") : original_title
    # Iterate with languages to find title in each of them
    languages.each do |language|
      url = "http://www.unesco.org/xtrans/bsresult.aspx?a=&stxt=#{query}&sl=&l=#{language}&c=&pla=&pub=&tr=&e=&udc=&d=&from=&to=&tie=a"
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      title = html_doc.search(".sn_target_title").first.nil? || html_doc.search(".sn_target_title").nil? ? nil : html_doc.search(".sn_target_title").first.text.strip
      if title.nil?
        clean_title = nil
      else
        # Cleaning title: removing parenthesis and semi-colons
        clean_title = title.match?(/\:(.*)/) ? title.gsub("\s", "") : title
        clean_title = title.match?(/\(([^)]+)\)/) ? title.gsub(/\(([^)]+)\)/, "").strip : title
      end
      result[language.to_sym] = clean_title
    end
    result
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
      if results[:original_title].nil?
        puts "no original title, no scraping unesco"
        Book.create(title: title, language: "english", country: country, author: author, image: results[:image], genre: "novel", original_title: nil)
        puts "book created"
      else
        puts "scraping unesco"
        alternative_titles = get_alternative_titles(results[:original_title])
        book = Book.create(title: title, language: "english", country: country, author: author, image: results[:image], genre: "novel", original_title: results[:original_title], fra_title: alternative_titles[:fra], spa_title: alternative_titles[:spa], description: results[:description], isbn: results[:isbn])
        puts "book created"
          new_title = {fra_title: book.fra_title, spa_title: book.spa_title}
            api_results = fetch_api(new_title)
            p api_results
            if !book.fra_title.nil?
              puts "creating a book in french"
            Book.create(title: book.fra_title, language: "french", country: book.country, author: book.author, image: api_results[:fra_results][:image], genre: "novel", original_title: book.original_title, description: api_results[:fra_results][:description])
            puts "book in French created"
            elsif !book.spa_title.nil?
              puts "creating a book in spanish"
            Book.create(title: book.spa_title, language: "spanish", country: book.country, author: book.author, image: api_results[:spa_results][:image], genre: "novel", original_title: book.original_title, description: api_results[:spa_results][:description])
            puts "book in Spanish created"
            end
      end
    end
   rescue URI::InvalidURIError
    puts "Invalid country"
  end
end

def scrape_one_book(book_url)
    url = "https://www.goodreads.com#{book_url}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    image = html_doc.search('#coverImage').attribute('src').value
    original_title = html_doc.search('.clearFloats:nth-child(1) .infoBoxRowItem').nil? ? "" : html_doc.search('.clearFloats:nth-child(1) .infoBoxRowItem').text.strip
    isbn = html_doc.search('#description a:nth-child(1)').nil? ? html_doc.search('#description a:nth-child(1)').first.text : html_doc.search('.clearFloats:nth-child(2) .infoBoxRowItem').text.strip
      clean_isbn = isbn.match?(/\(([^)]+)\)/) ? isbn.gsub(/\(([^)]+)\)/, "").strip : isbn
      if clean_isbn.to_i != 0
        clean_isbn
      else
        clean_isbn = nil
      end
    puts "isbn: #{clean_isbn}"
    results = fetch_api_description(clean_isbn)
    image == "" ? {image: image, original_title: original_title, description: results[:description], isbn: clean_isbn} : {image: results[:image], original_title: original_title, description: results[:description], isbn: clean_isbn}
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
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.last).save!
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.first).save!
BookshelfItem.new(bookshelf: Bookshelf.first, book: Book.second).save!
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.last).save!
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.first).save!
BookshelfItem.new(bookshelf: Bookshelf.last, book: Book.second).save!
puts "Creating reviews"
Review.new(user: User.first, book: Book.first, review_content: "I didn't like this book coz I can't read.", rating: 1).save
Review.new(user: User.second, book: Book.second, review_content: "I loved this book coz I can't read.", rating: 5).save
Review.new(user: User.second, book: Book.last, review_content: "It was OK.", rating: 3).save
Review.new(user: User.second, book: Book.first, review_content: "I hated this book coz I can read.", rating: 1).save
Review.new(user: User.last, book: Book.last, review_content: "Well, you know", rating: 3).save
puts "Seeding done..."
10.times { puts ">" }
puts "... Congratulations!"
