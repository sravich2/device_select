class AddProductsJob < ActiveJob::Base
  queue_as :default

  def perform()
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
end