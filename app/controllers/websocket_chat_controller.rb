require 'redis'
require 'benchmark'
require 'digest/sha1'
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
    dig = request.remote_ip.to_i * Time.zone.now.strftime("%d").to_i
    @client_ip = Digest::SHA1.hexdigest(dig.to_s).to_i(16).to_s(36)
    msg["first_id"] = @client_ip 
    send_message :websocket_chat,msg  
  end

  def new_message
   result = Benchmark.realtime do
    #クライアントからのメッセージを取得
    cid = Time.zone.now.strftime("%d%H%M%S%N").to_i.to_s(36)
    newtime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S")
    message[:comment_id] = cid
    message[:time] = newtime
    dig = request.remote_ip.to_i * Time.zone.now.strftime("%d").to_i
    message[:client_id] =  Digest::SHA1.hexdigest(dig.to_s).to_i(16).to_s(36)
    DatawriteJob.perform_later(message)
   end
   puts "#{result}s"
  end
  
  def exit
    logger.debug("disconnected user")
    gid = session[:group_id]
    controller_store[:topic].hincrby(gid,"visitor", -1)

  end
 end
