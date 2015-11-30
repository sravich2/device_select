require 'open-uri'

class Product < ActiveRecord::Base
  has_many :user_reviews

  def self.search(string)
    conditions = string.split(',').collect do |m|
      m.strip!
      delim = (m.include?('=') ? '=' : 'like')
      expr = m.split(/=|like/i)
      "#{expr[0].strip.downcase.tr(' ', '_')} #{delim} '#{expr[1].strip}'"
         end
    final_condition = conditions.join(' AND ')
    puts final_condition
    Product.where(final_condition)
  end

  def get_details_from_amazon
    product_page_url = fetch_amazon_page_url(self.name)
    product_page_html = open(product_page_url, "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(product_page_html)

    amazon_fields = {:camera => 'Webcam', :screen_size => 'Screen Size', :company => 'Brand Name', :memory => 'RAM', :processor => 'Processor', :battery => 'Average Battery Life (in hours)' }
    new_attrs = {}
    amazon_fields.keys.each do |f|
      attr = @html_doc.xpath("//div[@class='pdTab']/table/tbody/tr/td[contains(text(), '#{amazon_fields[f]}')]/following-sibling::td/text()").to_s
      puts attr
      unless attr.blank?
        new_attrs[f] = attr
      end
    end

    new_attrs[:img_url] = @html_doc.xpath("//li[contains(@class, 'itemNo0')]//img[contains(@id, 'landingImage')]/@src").to_s
    self.update(new_attrs)
    self.save!
  end

  private
  def fetch_amazon_page_url(product)
    product_param = product.downcase.split(' ').join('+')
    page_html = open("http://www.amazon.com/s/field-keywords=#{product_param}", "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(page_html)
    product_page_url = @html_doc.xpath("//li[@id='result_0']//a[contains(@class, 's-access-detail-page')]/@href").to_s
    ## Only for testing
    # product_page_html = open(product_page_url).read
    # @html_doc = Nokogiri::HTML(product_page_html)
    # screen_size = @html_doc.xpath("//td[text() = 'Brand Name']/following-sibling::td/text()").to_s

  end

  def fetch_engadget_page_url(product)
    product_param = product.downcase.split(' ').join('+')
    agent = Mechanize.new
    results_page = agent.get("https://www.google.com/search?q=#{product_param}+site%3Aengadget.com%2Fproducts")
    results_page.links[30].href.split('/url?q=')[1]
  end

  def get_details_from_bestbuy
    product_page_url = fetch_bestbuy_page_url(self.name)
    product_page_html = open(product_page_url, "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(product_page_html)

    bestbuy_fields = {:camera => 'Webcam', :screen_size => 'Screen Size', :company => 'Brand Name', :memory => 'RAM', :processor => 'Processor', :battery => 'Average Battery Life (in hours)' }
    new_attrs = {}
    bestbuy_fields.keys.each do |f|
      attr = @html_doc.xpath("//div[@class='pdTab']/table/tbody/tr/td[contains(text(), '#{bestbuy_fields[f]}')]/following-sibling::td/text()").to_s
      puts attr
      unless attr.blank?
        new_attrs[f] = attr
      end
    end

    new_attrs[:img_url] = @html_doc.xpath("//li[contains(@class, 'itemNo0')]//img[contains(@id, 'landingImage')]/@src").to_s
    self.update(new_attrs)
    self.save!
  end

  private
  def fetch_bestbuy_page_url(product)
    product_param = product.downcase.split(' ').join('+')
    page_html = open("http://www.bestbuy.com/site/searchpage.jsp?st=#{product_param}&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&cp=1&nrp=&sp=&qp=&list=n&iht=y&usc=All+Categories&ks=960&keys=keys", "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(page_html)
    product_page_url = @html_doc.xpath("//li[@id='result_0']//a[contains(@class, 's-access-detail-page')]/@href").to_s
    ## Only for testing
    # product_page_html = open(product_page_url).read
    # @html_doc = Nokogiri::HTML(product_page_html)
    # screen_size = @html_doc.xpath("//td[text() = 'Brand Name']/following-sibling::td/text()").to_s

  end

  def get_details_from_wikipedia
    product_page_url = fetch_wikipedia_page_url(self.name)
    product_page_html = open(product_page_url, "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(product_page_html)

    wikipedia_fields = {:camera => 'Webcam', :screen_size => 'Screen Size', :company => 'Brand Name', :memory => 'RAM', :processor => 'Processor', :battery => 'Average Battery Life (in hours)' }
    new_attrs = {}
    wikipedia_fields.keys.each do |f|
      attr = @html_doc.xpath("//div[@class='pdTab']/table/tbody/tr/td[contains(text(), '#{wikipedia_fields[f]}')]/following-sibling::td/text()").to_s
      puts attr
      unless attr.blank?
        new_attrs[f] = attr
      end
    end

    new_attrs[:img_url] = @html_doc.xpath("//li[contains(@class, 'itemNo0')]//img[contains(@id, 'landingImage')]/@src").to_s
    self.update(new_attrs)
    self.save!
  end

  private
  def fetch_wikipedia_page_url(product)
    product_param = product.downcase.split(' ').join('+')
    page_html = open("https://en.wikipedia.org/wiki/#{product_param}", "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(page_html)
    product_page_url = @html_doc.xpath("//li[@id='result_0']//a[contains(@class, 's-access-detail-page')]/@href").to_s
    ## Only for testing
    # product_page_html = open(product_page_url).read
    # @html_doc = Nokogiri::HTML(product_page_html)
    # screen_size = @html_doc.xpath("//td[text() = 'Brand Name']/following-sibling::td/text()").to_s

  end

end

