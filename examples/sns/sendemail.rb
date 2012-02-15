
require File.expand_path(File.dirname(__FILE__) + '/../config')

# get an instance of the SNS interface using the default configuration
sns = AWS::SNS.new

#see if our test already exists
matches = sns.topics.select {|item| item.name == "SNS"}

if matches.length > 1
  topic = matches.first
else
  topic = sns.topics.new "test"
end


#ruby sdk is borked. need to manually set a display name before doing sms..
topic.display_name = "SNS"
topic.subscribe("1-555-555-5555")

#subscribe via email
topic.subscribe "somebody@tcnj.edu"


#send a message. 
topic.publish("EPIC WIN")



sns.topics.each do |topic|
  puts "----------------------"
  puts "topic: #{topic.name}"
  puts "----------------------"
  
  # bucket.objects.each do |item|
  #     puts item.url_for :read
  #   end
  #   
  puts ""
end