Airbrake.configure do |config|
  config.api_key = 'REPLACE_ME'
  config.host    = 'errbit.hut.shefcompsci.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end