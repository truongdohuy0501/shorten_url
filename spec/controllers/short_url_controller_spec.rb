require "rails_helper"

RSpec.describe ShortUrlsController, type: :controller do
  let(:destination) { Faker::Internet.url }

  describe 'GET #index' do
    before { get :index }
    it { expect(response).to have_http_status(:success) }
    it { should render_template('index') }
  end

  describe "#create" do
    it do
      params = {
        short_url: {original_url: destination},
      }
      post :create, params: params

      expect(subject.send(:shorted_url_params)).to eq({"original_url"=> destination})
      expect(response).to have_http_status(302)
    end
  end

  describe "#create with exist url" do
    before { @shortened = ShortUrl.create(original_url: destination)}
    it do
      params = {
        short_url: {original_url: destination},
      }
      post :create, params: params

      expect(response.header["X-Frame-Options"]).to eq('SAMEORIGIN')
    end
  end

  describe "#create with long url" do
    destination = 'https://translate.google.com/?sl=auto&tl=en&text=Lorem%20ipsum%20dolor%20sit%20amet%2C%20consectetur%20
           adipiscing%20elit.%20Nulla%20accumsan%20erat%20id%20lorem%20suscipit%2C%20vel%20molestie%20libero%20fermentum.%20
           Nullam%20quis%20ipsum%20orci.%20Aliquam%20vestibulum%20nunc%20in%20venenatis%20aliquet.%20Pellentesque%20ut%20rhoncus.&op=translate'
    before { @shortened = ShortUrl.create(original_url: destination)}
    it do
      params = {
        short_url: {original_url: destination},
      }
      post :create, params: params

      expect(response).to have_http_status(:success)
      expect(controller).to set_flash.now[:error].to(/Url is too long/)
    end
  end

  describe "#shorted" do
    url = Faker::Internet.url
    before { 
      @shortened = ShortUrl.create(original_url: url)
    }
    it do
      params = {
        short_url: @shortened.shorted_url
      }

      get :shorted, params: params

      expect(response).to have_http_status(200)
      should render_template('shorted')
    end
  end

  describe "#show" do
    url = Faker::Internet.url
    before { 
      @shortened = ShortUrl.create(original_url: url)
    }
    it do
      params = {
        short_url: @shortened.shorted_url
      }

      get :show, params: params

      expect(response).to have_http_status(302)
    end
  end
end
