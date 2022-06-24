# ShortUrlsController

class ShortUrlsController < ApplicationController
  before_action :find_url, only: [:show, :shorted]

  def index
    @url = ShortUrl.new
  end

  def show
    uri = URI.parse(@url.sanitize_url)
    redirect_to(uri.to_s)
  end
  
  def encode
  end

  def decode
  end

  def create
    @url = ShortUrl.new shorted_url_params
    @url.sanitize
    if @url.sanitize.length > 255
      flash.now[:error] = "Url is too long"
      return render :index
    end
    
    if @url.new_url?
      if @url.save
        redirect_to shorted_path @url.shorted_url
      else
        flash.now[:error] = "The URL is not valid, make sure the URL you tried to shorten is correct"
        render :index
      end
    else
      flash.now[:notice] = "A short link for this URL is existed!"
      redirect_to shorted_path @url.find_duplicate.shorted_url
    end
  end

  def shorted
    host = request.host_with_port
    @original_url = @url.sanitize_url
    @shorted_url = [host,SHORT_URL, @url.shorted_url].join "/"
  end
  
  private

  def find_url
    @url = ShortUrl.find_by_shorted_url params[:short_url]
  end

  def shorted_url_params
    params.require(:short_url).permit :original_url
  end
end
