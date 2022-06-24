require "rails_helper"

RSpec.describe Api::V1::ShortUrlsController, type: :controller do
  let(:destination) { Faker::Internet.url }

  describe "#create with exist url" do
    before { @shortened = ShortUrl.create(original_url: destination)}
    it do
      params = {
        short_url: {original_url: destination},
      }
      post :encode_shorted_url, params: params

      expect(response.header["X-Frame-Options"]).to eq("SAMEORIGIN")
    end
  end

  describe "#create with long url" do
    destination = "https://translate.google.com/?sl=auto&tl=en&text=Lorem%20
           ipsum%20dolor%20sit%20amet%2C%20consectetur%20
           adipiscing%20elit.%20Nulla%20accumsan%20erat%20id%20lorem%
           20suscipit%2C%20vel%20molestie%20libero%20fermentum.%20
           Nullam%20quis%20ipsum%20orci.%20Aliquam%20vestibulum%20nunc%20in%20venenatis%20aliquet.%20
           Pellentesque%20ut%20rhoncus.&op=translate"
    before { @shortened = ShortUrl.create(original_url: destination)}
    it do
      params = {
        short_url: {original_url: destination},
      }
      post :encode_shorted_url, params: params

      expect(response).to have_http_status(:success)
      expect(response.content_type == "application/vnd.api+json")
      expect(JSON(response.body)["error"]["message"]).to eq("Url is too long")
    end
  end
end
