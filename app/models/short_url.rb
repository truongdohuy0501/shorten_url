class ShortUrl < ApplicationRecord
  UNIQ_ID_LENGTH = 6
  REGEX_LINK = /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/  # Regex cho link nhập

  validates :original_url, presence: true, on: :create
  validates :original_url, format: {with: REGEX_LINK}, if: :validate_original_url?
  before_create :generate_shorted_url
  before_create :sanitize

  def validate_original_url?
    original_url.present?
  end

  def generate_shorted_url
    url = ([*("a".."z"),*("0".."9")]).sample(UNIQ_ID_LENGTH).join
    old_url = ShortUrl.where(shorted_url: url).last
    if old_url.present?
      self.generate_shorted_url
    else
      self.shorted_url = url
    end
  end

  def find_duplicate
    ShortUrl.find_by_sanitize_url self.sanitize_url
  end

  def new_url?
    find_duplicate.nil?
  end

  def sanitize
    self.original_url.strip!
    byebug
    self.sanitize_url = self.original_url.downcase.gsub /(https?:\/\/|(www\.))/, ""
    self.sanitize_url = "http://#{self.sanitize_url}"
  end
end
