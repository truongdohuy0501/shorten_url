class ShortUrlsController < ApplicationController
  before_action :find_url, only: [:show, :shorted]

  SHORT_URL = 'shorted'.freeze

  def index
    @url = ShortUrl.new
  end
  
  def encode;end

  def decode;end

  def decode_shorted_url
    @url = ShortUrl.find_by_shorted_url(shorted_params)

    return render json: { error: { message: 'Url does not existed' } } if @url.nil?
    render json: { original_url: @url.original_url }
  end

  def create
    @url = ShortUrl.new short_urls_params
    @url.sanitize

    return render json: { error: { message: 'Url is too long' } } if @url.sanitize.length > 255
    host = request.host_with_port

    if @url.new_url?
      if @url.save
        end_link = [host, SHORT_URL, @url.shorted_url].join "/"
        return render json: { shorted_url: "#{end_link}" }
      else
        return render json: { error: { message: 'The URL is not valid, make sure the URL you tried to shorten is correct' } }
      end
    else
      end_link = [host, SHORT_URL, @url.find_duplicate.shorted_url].join "/"
      return render json: { duplicate: { message: 'A short link for this URL is existed!' }, shorted_url: "#{end_link}"}
    end
  end

  def shorted
    host = request.host_with_port
    @original_url = @url.sanitize_url
    @shorted_url = [host,SHORT_URL, @url.shorted_url].join "/"
  end
  
  private

  def params_permit
    params.permit!
  end

  def find_url
    @url = ShortUrl.find_by_shorted_url params[:shorted_url]
  end

  def short_urls_params
    params.require(:short_url).permit :original_url
  end

  def shorted_params
    shorted_params = params.require(:short_url).permit :shorted_url
    shorted_params[:shorted_url].split("/").last
  end
end
