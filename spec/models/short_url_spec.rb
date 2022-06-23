require "./spec/rails_helper"

RSpec.describe ShortUrl, type: :model do
  it { should validate_presence_of(:original_url) }
  

  context "has a valid with regex" do
    url = Faker::Internet.url
    it { should allow_value(url).for(:original_url)}
  end

  context "validate presence_of original_url" do
    subject { build(:short_url) }

    it { should validate_presence_of(:original_url) }
  end

  context "validate lenght of shorted_url" do
    subject { build(:short_url) }

    it { should validate_length_of(:shorted_url) }
  end

  context "shortened url record for requested url does not exist" do
    let(:expected_url) { Faker::Internet.url }
    let(:short_url) { ShortUrl.create(original_url: expected_url) }
    it "creates a shortened url record for the url" do
      expect(short_url.original_url).to eq expected_url
      expect(short_url.shorted_url.length).to eq 6
    end
  end
end
