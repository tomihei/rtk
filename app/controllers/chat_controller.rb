class ChatController < ApplicationController
  def index
    gid = params[:id]
    if Topic.exists?(:key => "#{gid}")
      session[:group_id] = gid
      @title = $redistopic.hget(gid,"title") 
    else 
      render :text => "そんなのないよ", :status => 404
    end
  end
  
  def main
    
  end

end
