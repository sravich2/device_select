class FetchCriticReviewsJob < ActiveJob::Base
  queue_as :default

  def perform(product)
    page_url = Product.fetch_engadget_page_url(product.name) + 'scores/'
    puts page_url
    agent = Mechanize.new
    page = agent.get(page_url)
    xpaths = ['div.border-bottom:nth-child(4) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(1)',
              'div.border-bottom:nth-child(5) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(1)',
              'div.border-bottom:nth-child(6) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(1)']
    xpaths.each do |xp|
      q = page.search(xp).text.delete("\n").strip
      page2 = agent.get("http://www.google.com/search?q=#{q}")
      url = page2.links_with(:href => %r"/url.+").first.href.split('/url?q=')[1].split('&sa')[0]
      begin
        html, title, author, published = Product.generate_readable_html(url)
        summary = Product.generate_summary(html)
        CriticReview.create(:product_id => product.id, :url => url, :page_html => html, :title => title, :author => author, :published => published, :summary => summary)
      rescue
      end
    end
  end
end
