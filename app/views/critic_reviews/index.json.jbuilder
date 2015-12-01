json.array!(@critic_reviews) do |critic_review|
  json.extract! critic_review, :id
  json.url critic_review_url(critic_review, format: :json)
end
