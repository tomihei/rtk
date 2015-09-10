require 'redis'
#websocketRails::BaseControllerを継承
class WebsocketChatController < WebsocketRails::BaseController
  
  def initialize_session
    logger.debug("initialize chat controller")
    puts "initialize"
    @redis = Redis.new(:host => "pub-redis-14162.us-east-1-2.4.ec2.garantiadata.com"  , :port => 14162 , :password => "PGjUZkCa9yo1D7q5")   
        controller_store[:redis] = @redis
    
  end

  def connect_user

    gid = session[:group_id] 
    WebsocketRails["#{gid}"].filter_with(WebsocketChatController, :new_message)

    logger.debug("connected user")
    puts "connect_user"
    talks = controller_store[:redis].lrange gid, 0,-1
    puts "co"
    talks.each do |message|
      msg = ActiveSupport::HashWithIndifferentAccess.new(eval(message))
      send_message :websocket_chat,msg 
      puts "ag"
    end
    puts "d"
  end

  def new_message  
    #クライアントからのメッセージを取得
    logger.debug("Call new_message ")
    puts "new"
    gid = message[:group_id]
    message[:time] = Time.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    puts "a"
    message[:client_id] = client_id
    puts "b"
    #レス番号付加
    talknum = controller_store[:redis].llen gid
    message[:resnum] = talknum + 1
    #redisに保存
    controller_store[:redis].rpush gid, message
  end
  
 end
