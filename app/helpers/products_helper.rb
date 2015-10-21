require 'open-uri'
module ProductsHelper
  def fetch_amazon_page_url(product)
    product_param = product.downcase.split(' ').join('+')
    page_html = open("http://www.amazon.com/s/field-keywords=#{product_param}").read
    @html_doc = Nokogiri::HTML(page_html)
    @html_doc.xpath("//li[@id='result_0']//a[contains(@class, 's-access-detail-page')]/@href").to_s
  end
end
