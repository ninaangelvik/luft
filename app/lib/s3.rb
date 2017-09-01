require 'aws-sdk-v1'
class S3Store
  BUCKET = "luftprosjekttromso".freeze

  def initialize file
    @file = file
    @s3 = AWS::S3.new
    @bucket = @s3.buckets[BUCKET]
  end

  def store
    @obj = @bucket.objects[@file.filename].write(@file.data)
  end

  def url
    @obj.public_url.to_s
  end

  private
  
  def filename
    @filename ||= @file.filename.gsub(/[^a-zA-Z0-9_\.]/, '_')
  end
end