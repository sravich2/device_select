class FetchCriticReviewsJob < ActiveJob::Base
  queue_as :default

  def perform(product)
    begin
    page_url = Product.fetch_engadget_page_url(product.name) + 'scores'
      agent = Mechanize.new
      page = agent.get(page_url)
      xpaths = ['/html/body/div/div/div[2]/main/div[2]//div[2]/div/div/div/div[1]/div/div[4]/div/div[2]/div[1]/div',
                '/html/body/div/div/div[2]/main/div[2]//div[2]/div/div/div/div[1]/div/div[5]/div/div[2]/div[1]/div',
                '/html/body/div/div/div[2]/main/div[2]//div[2]/div/div/div/div[1]/div/div[6]/div/div[2]/div[1]/div']
      xpaths.each do |xp|
        q = page.search(xp).text.delete("\n").strip
        page2 = agent.get("http://www.google.com/search?q=#{q}")
        url = page2.links[24].href.split('/url?q=')[1].split('&sa')[0]
        html, title, author, published = Product.generate_readable_html(url)
        summary = Product.generate_summary(html)
        CriticReview.create(:product_id => product.id, :url => url, :page_html => html, :title => title, :author => author, :published => published, :summary => summary)
      end
    end
    rescue
  end
end
