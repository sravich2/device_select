class FetchCriticReviewsJob < ActiveJob::Base
  queue_as :default

  def perform(product)
    page_url = Product.fetch_engadget_page_url(product.name) + 'scores'
    agent = Mechanize.new
    page = agent.get(page_url)
    xpaths = ['/html/body/div/div/div[2]/main/div[2]/div[4]/div[2]/div/div/div/div[1]/div/div[3]/div/div[2]/div[1]/div',
    '/html/body/div/div/div[2]/main/div[2]/div[4]/div[2]/div/div/div/div[1]/div/div[4]/div/div[2]/div[1]/div',
              '/html/body/div/div/div[2]/main/div[2]/div[4]/div[2]/div/div/div/div[1]/div/div[5]/div/div[2]/div[1]/div']
    page.search()

  end
end
