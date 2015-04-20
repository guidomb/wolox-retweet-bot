require 'dotenv'
require 'twitter'

Dotenv.load

stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['ACCOUNT_OAUTH_TOKEN']
  config.access_token_secret = ENV['ACCOUNT_OAUTH_SECRET']
end

rest_client = Twitter::REST::Client.new do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['ACCOUNT_OAUTH_TOKEN']
  config.access_token_secret = ENV['ACCOUNT_OAUTH_SECRET']
end

accounts = {
  "wolox" => 202739320,
  "woloxiot" => 2892166253,
  "woloxeng" => 590254332,
  "syrmoskate" => 1265759042,
  "john_snow_bot" => 3184142433
}

is_own_retweet = Regexp.new("RT @(#{accounts.keys.join('|')}).*", Regexp::IGNORECASE)

puts "Following accounts: #{accounts.keys.join(", ")}"
stream_client.filter(follow: accounts.values.join(",")) do |object|
  next unless object.is_a?(Twitter::Tweet) && !(is_own_retweet === object.text)
  puts "Retweeting status: '#{object.text}'"
  rest_client.retweet(object)
end
