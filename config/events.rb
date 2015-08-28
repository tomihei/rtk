WebsocketRails::EventMap.describe do

  subscribe :client_connected, to: WebsocketChatController,
  with_method: :connect_user
  # websocket_chatイベントのマッピング
 
  subscribe :websocket_chat, to: WebsocketChatController,
  with_method: :new_message
 
end

