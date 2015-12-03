require 'open-uri'

class Product < ActiveRecord::Base
  has_many :user_reviews
  has_many :critic_reviews

  def self.search(string)
    sort = false
    new_string = string

    if new_string.blank?
      products = Product.all
    else
      if string.split(',')[-1].strip.start_with?('sort')
        sort = true
        order_param = string.split(',')[-1].strip
        last_index = string.rindex(',')
        if !last_index.nil?
          new_string = string[0..last_index]
        else
          new_string = ''
        end
        order = order_param.split('sort:')[1].strip
        s = order.split(' ', 2)
        hash = {s[1].downcase.tr(' ', '_').to_sym => s[0].to_sym}
      end
      if new_string.blank?
        products = Product.all
      else
        conditions = new_string.split(',').collect do |m|
          m.strip!
          delim = (m.include?('=') ? '=' : 'like')
          expr = m.split(/=|like/i)
          "#{expr[0].strip.downcase.tr(' ', '_')} #{delim} '#{expr[1].strip}'"
        end

        final_condition = conditions.join(' AND ')
        products = Product.where(final_condition)
      end
    end

    if sort
      return products.order(hash)
    else
      return products
    end
  end

  def get_details_from_amazon
    product_page_url = fetch_amazon_page_url(self.name)
    product_page_html = open(product_page_url, "User-Agent" => "Device Select").read
    @html_doc = Nokogiri::HTML(product_page_html)

    amazon_fields = {:camera => 'Webcam', :screen_size => 'Screen Size', :company => 'Brand Name', :memory => 'RAM', :processor => 'Processor', :battery => 'Average Battery Life (in hours)'}
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


  def price_alert

  end

  def self.generate_readable_html(url)
    readability_url = "http://www.readability.com/m?url=#{CGI::escape(url)}"
    html_content = open(readability_url).read
    html_doc = Nokogiri::HTML(html_content)
    complete_content_html = html_doc.search('//article').first.to_html
    complete_content_html_doc = Nokogiri::HTML(complete_content_html)
    # header_html = html_doc.search('//header').first.to_html
    title = html_doc.search('//header')[1].css('h1[id=rdb-article-title]').text
    doc = Pismo::Document.new(url)
    author = doc.author
    published = doc.datetime

    content_html_doc = complete_content_html_doc.search('//section').first
    content_html_doc.search('//ul').each do |node|
      node.remove
    end

    original_html = Nokogiri::HTML(open(url).read)
    css_lines = original_html.css('link[href$=css]')

    final_html = '<html><head>'
    css_lines.each do |line|
      # final_html = final_html + line.to_html
    end
    return final_html + "</head><body>#{content_html_doc.to_html}</body></html>", title, author, published
  end

  # Returns array of sentences
  def self.generate_summary(html)
    html_doc = Nokogiri::HTML(html)
    paragraphs = []
    m = TactfulTokenizer::Model.new
    tokenizer = Tokenizer::Tokenizer.new
    html_doc.search('p').each do |p|
      paragraphs << m.tokenize_text(p.text) unless p.text.blank? || p.text.length <= 50 || p.text.downcase.include?('comments')
    end
    sentences = paragraphs.flatten
    sentence_pair_scores = Hash.new
    sentences.each do |s1|
      sentences.each do |s2|
        if s1 == s2
          sentence_pair_scores[[s1, s2]] = 0
        else
          sentence_pair_scores[[s1, s2]] = (tokenizer.tokenize(s1).select { |t| Stopwords.valid?(t) } & tokenizer.tokenize(s2).select { |t| Stopwords.valid?(t) }).count
        end
      end
    end
    sentence_scores = {}
    sentences.each do |s|
      sentence_scores[s] = 0
      sentences.each do |s2|
        sentence_scores[s] += sentence_pair_scores[[s, s2]]
      end
    end
    full_summary = paragraphs.collect { |p| sentence_scores.slice(*p).sort_by {|_, v| -v }.first }
    threshold = full_summary.sort_by {|sentence, score| -score}[5][1]
    summary = sentence_scores.select { |s, score| s if score >= threshold}.keys
    # Ensure a sentence from first and last paragraphs
    summary.unshift(full_summary.first[0]) if full_summary.first[1] < threshold
    summary << full_summary.last[0] if full_summary.last[1] < threshold
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
    results_page.links[24].href.split('/url?q=')[1].split('&sa')[0]
  end

end


