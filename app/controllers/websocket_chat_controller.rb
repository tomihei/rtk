require 'redis'
#websocketRails::BaseControllerを継承
class WebsocketChatController < WebsocketRails::BaseController
  
  def initialize_session
    logger.debug("initialize chat controller")
    puts "initialize"
    controller_store[:redis] = $rediscont
    controller_store[:topic] = $redistopic
  end

  def connect_user

    gid = session[:group_id] 
      WebsocketRails["#{gid}"].filter_with(WebsocketChatController, :new_message)
    
    #入室数あげ
    controller_store[:topic].hincrby(gid,"visitor", 1)

    logger.debug("connected user")
    msg = {}
    msg["first_id"] = client_id 
    send_message :websocket_chat,msg  
  end

  def new_message  
    #クライアントからのメッセージを取得
    logger.debug("Call new_message ")
    newtime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    message[:time] = newtime
    message[:client_id] = client_id
    DatawriteJob.perform_later(message)
  end
  
  def exit
    logger.debug("disconnected user")
    gid = session[:group_id]
    controller_store[:topic].hincrby(gid,"visitor", -1)

  end
 end
