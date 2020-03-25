require 'open-uri'
require 'nokogiri'

def scrape_books
  countries = ["DNK", "NOR", "SWE"]
  languages = ['eng', 'ron', 'ita', 'fra', 'spa', 'deu']
  countries.each do |country|
    languages.each do |language|
      url = "http://www.unesco.org/xtrans/bsresult.aspx?a=&stxt=&sl=&l=ita&c=ROU&pla=&pub=&tr=&e=&udc=&d=&from=1990&to=&tie=a"
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      html_doc.search('td.res2').each do |element|
        author = "#{element.search('.sn_auth_firstname').text.strip} #{element.search('.sn_auth_name').text.strip}"
        puts author
        # Book.new(title: "Harold et Maude", genre: "novel", language: "french").save
      end
    end
  end
end


scrape_books
