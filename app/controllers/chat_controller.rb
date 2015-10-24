class ChatController < ApplicationController
  def index
    session[:group_id] = params[:id]
    hkey = params[:id]
    @title = Topic.find_by_key(hkey)
  end
  
  def main
    
  end

end
