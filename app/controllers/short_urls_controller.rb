class ShortUrlsController < ApplicationController
  before_action :find_url, only: [:show, :shorted]

  def index
    @url = ShortUrl.new
  end

  def show
    redirect_to @url.sanitize_url
  end

  def create
    @url = ShortUrl.new short_urls_params
    @url.sanitize
    if @url.new_url?
      if @url.save
        redirect_to shorted_path @url.shorted_url
      else
        flash.now[:error] = "Check the errors below"
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
    @shorted_url = [host, @url.shorted_url].join "/"
  end

  private

  def find_url
    @url = ShortUrl.find_by_shorted_url params[:shorted_url]
  end

  def short_urls_params
    params.require(:short_url).permit :original_url
  end
end
