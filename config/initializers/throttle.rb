require "redis"

THROTTLE_MAX_REQUESTS = 60
THROTTLE_TIME_WINDOW = 15 * THROTTLE_MAX_REQUESTS

redis_conf  = YAML.load(File.join(Rails.root, "config", "redis.yml"))
REDIS = Redis.new(:host => redis_conf["host"], :port => redis_conf["port"])
