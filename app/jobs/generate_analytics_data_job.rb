class GenerateAnalyticsDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
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
