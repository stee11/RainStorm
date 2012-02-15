class HomesController < ApplicationController
  # GET /homes
  # GET /homes.xml
  def index
    
    @subs = getTopic().subscriptions
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /send
  def sendmessage
   topic = getTopic
   msg = params[:message]
   
   if msg == nil || msg.length == 0
      redirect_to("/homes", :alert => "Failed to Send Message. Message was empty")
      return  
   end
    
   #send a message. 
   res = topic.publish(msg)
   
   if res == nil
     redirect_to("/homes", :alert => "Failed to Send Message")
     return
   end
   
   respond_to do |format|
       format.html { redirect_to("/homes", :notice => "Message was sent. result: #{res}") }
   end
  end


  def subscribe
    topic = getTopic
    email = params[:email]
    
    isPhone = (email.match(/\d-\d\d\d-\d\d\d-\d\d\d\d/) != nil)
    
    #ruby sdk is borked. need to manually set a display name before doing sms...
    topicName = "SNS"
    topic.display_name = topicName if isPhone
        
    begin
      topic.subscribe(email)    
    rescue ArgumentError => e
      redirect_to("/homes", :alert => "Failed to subscribe, #{e.message}")
      return
    end
    
    respond_to do |format|
      format.html { redirect_to("/homes", :notice => "Confirmatin sent to #{email}") }
    end    
  end
  
  # POST /delete
  def delete
    endpoint = params[:id]
    
    topic = getTopic
    ep = topic.subscriptions.select { |item| item.endpoint == endpoint }
    
    #unsubscribe the first subscription found
    begin
      ep.first.unsubscribe if ep.length > 0
    rescue AWS::SNS::Errors::InvalidParameter => e
      redirect_to("/homes", :alert => "Failed to unsubscribe, Not subscribed")
      return
    end
    
    respond_to do |format|
      format.html { redirect_to("/homes", :notice => "Unsubscribed") }
    end
  end
  
  
  def getTopic
    topicName = "SNS"
    sns = AWS::SNS.new
    #see if our test already exists
    matches = sns.topics.select {|item| item.name == topicName}

    if matches.length > 1
      topic = matches.first
    else
      topic = sns.topics.create(topicName)
    end
    
    return topic
  end
end
