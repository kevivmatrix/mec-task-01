require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  s3_config = YAML::load(File.read(Rails.root.join('config','s3.yml')))[Rails.env]  
  
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     s3_config['access_key_id'],
    aws_secret_access_key: s3_config['secret_access_key'],
    region:                'ap-south-1',
    # host:                  's3.example.com',             # optional, defaults to nil
    # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = s3_config['bucket_name']
  config.fog_public     = false
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}

  if Rails.env.test?
    config.enable_processing = false
  end
end
