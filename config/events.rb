WebsocketRails::EventMap.describe do

  subscribe :client_connected, to: WebsocketChatController,
  with_method: :connect_user
  # websocket_chatイベントのマッピング

  subscribe :connection_closed, to: WebsocketChatController,
  with_method: :exit


  subscribe :client_disconnected, to: WebsocketChatController,
  with_method: :exit
  
  subscribe :websocket_chat, to: WebsocketChatController,
  with_method: :new_message
 
end

