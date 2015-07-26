#websocketRails::BaseControllerを継承
class WebsocketChatController < WebsocketRails::BaseController
  
  def initialize_session
    logger.debug("initialize chat controller")
  end

  def connect_user
    logger.debug("connected user")
  end


  def new_message 
    #クライアントからのメッセージを取得
    
    gid = message[:group_id]
    #websocket_chatイベントで接続しているクライアントにブロードキャスト

    WebSocketRails["#{gid}"].trigger(:websocket_chat,message)
  end
  
  def message_oppai_recieve
    
   new_message = {:message => 'おっぱい'}
   
   WebSocketRails["#{gid}"].trigger(:websocket_oppai,message)
  end

 end
