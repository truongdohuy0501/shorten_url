class ApplicationController < ActionController::Base
  before_action :throttle

  SHORT_URL = "shorted".freeze

  def throttle
    client_ip = request.env["REMOTE_ADDR"]
    key = "count:#{client_ip}"
    count = REDIS.get(key)

    unless count
      REDIS.set(key, 0)
      REDIS.expire(key, THROTTLE_TIME_WINDOW)
      return true
    end

    if count.to_i >= THROTTLE_MAX_REQUESTS
      message = "You have fired too many requests. Please try after 15 minutes."
      return render json: { error: { message: message } }, :status => 429
    end
    REDIS.incr(key)
    true
  end
end
