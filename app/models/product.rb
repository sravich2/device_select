require 'open-uri'
require 'rubygems'
require 'readability'

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

  def get_critic_reviews
    product_page_url = fetch_engadget_page_url(self.name)
    agent = Mechanize.new
    product_page = agent.get(product_page_url)
    product_page.links_with(:text => /Read the full review.+/)[0...1].each do |link|
      puts link.href
      puts generate_readable_html(link.href)
    end
  end


  private

  def generate_readable_html(url)
    readability_url = "http://www.readability.com/read?url=#{url}"
    html_content = open(readability_url).read
    html_doc = Nokogiri::HTML(html_content)
    complete_content_html = html_doc.search('//article').first.to_html
    complete_content_html_doc = Nokogiri::HTML(complete_content_html)
    header_html = html_doc.search('//header').first.to_html
    content_html_doc = complete_content_html_doc.search('//section').first
    content_html_doc.search('//ul').each do |node|
      node.remove
    end

    original_html = Nokogiri::HTML(open(self.url).read)
    css_lines = original_html.css('link[href$=css]')

    final_html = '<html><head>'
    css_lines.each do |line|
      final_html = final_html + line.to_html
    end
    final_html = final_html + "</head><body>#{content_html_doc.to_html}</body></html>"
  end


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
    results_page.links[24].href.split('/url?q=')[1].split('&sa')[0]
  end

end

