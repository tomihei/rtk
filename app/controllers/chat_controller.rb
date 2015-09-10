class ChatController < ApplicationController
  def index
    session[:group_id] = params[:id]
  end
end
