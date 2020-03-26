# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts "Cleaning DB"
User.destroy_all
Book.destroy_all

puts "Creating Users"
User.new(username: "maddy", password: "password", email: "maddy@book.com", preferred_language: "english").save
User.new(username: "ghita", password: "password", email: "ghita@book.com", preferred_language: "english").save
User.new(username: "sano", password: "password", email: "sano@book.com", preferred_language: "english").save
User.new(username: "rafiki", password: "password", email: "rafiki@book.com", preferred_language: "french").save
puts "Creating Books"
Book.new(title: "Harold et Maude", genre: "novel", language: "french", author: "name").save
Book.new(title: "Ulysses", genre: "novel", language: "english", author: "name").save
Book.new(title: "War and Peace", genre: "novel", language: "english", author: "name").save
Book.new(title: "Narnia", genre: "fantasy", language: "english", author: "name").save
Book.new(title: "Hobbit", genre: "novel", language: "english", author: "name").save
Book.new(title: "Poems by Me", genre: "poem", language: "english", author: "name").save
Book.new(title: "Hubs and cities in Middle Ages (Europe)", genre: "history", language: "english", author: "name").save
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
