require 'open-uri'
require 'nokogiri'


def scrape_books(country)
  query = country.match?("\s") ? country.gsub("\s", "%20") : country
  url = "https://www.goodreads.com/shelf/show/#{query}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search('.elementList').first(2).each do |book|
    title = book.search('a').attribute('title').value
    author = book.search('.authorName').text
    image = book.search('img').attribute('src').value
    Book.create(title: title, language: country)
  end
end

def scrape_countries

  url = "https://www.worldometers.info/geography/alphabetical-list-of-countries/"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search('tr').first(1).each do |element|
    country = element.search('td:nth-child(2)').text.strip.downcase
      scrape_books(country)
  end
end
