require 'redis'
#websocketRails::BaseControllerを継承
class WebsocketChatController < WebsocketRails::BaseController
  
  def initialize_session
    logger.debug("initialize chat controller")
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password )
    controller_store[:redis] = @redis
  end

  def connect_user
    gid = session[:group_id] 
    WebsocketRails["#{gid}"].filter_with(WebsocketChatController, :new_message)
      logger.debug("connected user")
    talks = controller_store[:redis].lrange gid, 0,-1
    talks.each do |message|
      msg = ActiveSupport::HashWithIndifferentAccess.new(eval(message))
      send_message :websocket_chat,msg 
    end
  end

  def new_message  
    #クライアントからのメッセージを取得
    logger.debug("Call new_message ") 
    gid = message[:group_id]
    message[:time] = Time.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    message[:client_id] = client_id
    #レス番号付加
    talknum = controller_store[:redis].llen gid
    message[:resnum] = talknum + 1
    #redisに保存
    controller_store[:redis].rpush gid, message
  end
  
 end
