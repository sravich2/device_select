class Jobs

  def self.AddProducts
    products = ["Macbook Pro", "Lenovo Yoga", "Surface Book", "Samsung Galaxy S5", "Samsung Galaxy S2", "Toshiba Excite", "Dragon Touch", "Tagital", "ASUS", "Acer Iconia", "Nexus 7", "Lenovo Tab", "Lenovo IdeaTab", "Dell Venue 8", "Samsung Galaxy Tab", "Toshiba Encore", "Microsoft Surface 3", "HP 8", "Ipad", "Ipad 2", "HP Pavilion", "Toshiba Satellite", "Acer Chromebook", "Sony Xperia", "HP Stream", "Acer Cloudbook", "Lenovo flex", "Microsoft Surface Pro", "Dell Latitude", "Acer Aspire One Cloudbook", "Aspire Switch", "Acer Aspire", "HP Spectre", "HP EliteBook Folio 1020", "Lenovo ThinkPad", "Lenovo ThinkPad Yoga 15", "Toshiba Portege", "Samsung Chromebook", "Samsung ATIV"]
    begin
      products.each do |p|
        unless Product.where(:name => p).exists?
          prod = Product.create(:name => p)
          prod.get_details_from_amazon
        end
      end
    end
  rescue
    sleep(1)
    retry
  end

  def self.fetch_critic_reviews(product)
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

  def self.generate_analytics_data
    r = SimpleRandom.new
    have = 0
    like = 0
    date = Date.today
    price = 1499

    100.times do |i|
      have += r.normal(8 - i*8/100, 4).to_i.abs
      like += r.normal(25 - i * 25/100, 10).to_i.abs
      AnalyticsStat.create(:product_id => Product.first.id, :have_count => have, :like_count => like, :date => date, :price => price)
      price -= price * rand(10)/100 if rand(30) > 28
      date = date.next_day
    end
  end
end