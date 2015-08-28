require 'redis'
#websocketRails::BaseControllerを継承
class WebsocketChatController < WebsocketRails::BaseController
  
  def initialize_session
    logger.debug("initialize chat controller")
    @redis = Redis.new(:host => "127.0.0.1", :port => 6379)
    controller_store[:redis] = @redis
  end

  def connect_user
    gid = session[:group_id] 
    WebsocketRails["#{gid}"].filter_with(WebsocketChatController, :new_message)
    logger.debug("connected user")
    talks = controller_store[:redis].lrange gid, -50,-1
    talks.each do |message|
      msg = ActiveSupport::HashWithIndifferentAccess.new(eval(message))
      send_message :websocket_chat,msg 
      
    end
  end

  def new_message  
    #クライアントからのメッセージを取得
    logger.debug("Call new_message ") 
    gid = message[:group_id]
    message[:time] = Time.now.strftime("%H時%M分").to_s
    controller_store[:redis].rpush gid, message
  end
  
 end
