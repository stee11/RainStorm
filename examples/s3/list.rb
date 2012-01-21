
require File.expand_path(File.dirname(__FILE__) + '/../config')

# get an instance of the S3 interface using the default configuration
s3 = AWS::S3.new

# list all files in all buckets
s3.buckets.each do |bucket|
  puts "----------------------"
  puts "bucket: #{bucket.name}"
  puts "----------------------"
  
  bucket.objects.each do |item|
    puts item.url_for :read
  end
  
  puts ""
end