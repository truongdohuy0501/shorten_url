# frozen_string_literal: true

module Api
  module V1
    class ShortUrlsController < ApplicationController
      def decode_shorted_url
        url_decode_redis = $redis.get(shorted_params)
        return render json: JSON.parse(url_decode_redis) if url_decode_redis.present?

        @url = ShortUrl.find_by_shorted_url(shorted_params)

        return render json: { error: { message: "Url does not existed" } } if @url.nil?

        render_redis_decode = { original_url: @url.original_url }.to_json
        $redis.set(shorted_params, render_redis_decode)
        render json: { original_url: @url.original_url }
      end

      def encode_shorted_url
        redis_key = short_urls_params[:original_url]
        url_redis = $redis.get(redis_key)

        return render json: JSON.parse(url_redis) if url_redis.present?

        @url = ShortUrl.new short_urls_params
        @url.sanitize
    
        return render json: { error: { message: "Url is too long" } } if @url.sanitize.length > 255
        host = request.host_with_port
    
        if @url.new_url?
          return render json: { error: { message: "The URL is not valid, make sure the URL you tried to shorten is correct" } } unless @url.save
          end_link = [host, SHORT_URL, @url.shorted_url].join "/"
          render_redis = { duplicate: { message: "A short link for this URL is existed!" }, shorted_url: end_link}.to_json
          $redis.set(redis_key, render_redis)
          render json: { shorted_url: end_link }
        else
          end_link = [host, SHORT_URL, @url.find_duplicate.shorted_url].join "/"
          render json: { duplicate: { message: "A short link for this URL is existed!" }, shorted_url: end_link}
        end
      end

      private

      def short_urls_params
        params.require(:short_url).permit :original_url
      end

      def shorted_params
        shorted_params = params.require(:short_url).permit :shorted_url
        shorted_params[:shorted_url].split("/").last
      end
    end
  end
end
