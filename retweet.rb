require 'dotenv'
require 'tweetstream'

Dotenv.load

TweetStream.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['ACCOUNT_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['ACCOUNT_OAUTH_SECRET']
  config.auth_method        = :oauth
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

stream_client = TweetStream::Client.new
puts "Following accounts: #{accounts.keys.join(", ")}"
stream_client.follow(accounts.values) do |status|
  puts "Retweeting status #{status.text}"
  rest_client.retweet(status)
end
