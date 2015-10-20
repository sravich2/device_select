json.array!(@websites) do |website|
  json.extract! website, :id
  json.url website_url(website, format: :json)
end
