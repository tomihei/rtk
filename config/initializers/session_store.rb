# Be sure to restart your server when you modify this file.

WebsocketTest::Application.config.session_store :cookie_store, key: '_websocket_test_session'
Rails.application.config.session_store :cookie_store, key: '_wow_session', expire_after: 3.minutes
