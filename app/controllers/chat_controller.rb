class ChatController < ApplicationController
  def index
    gid = params[:id]
    if Topic.exists?(:key => "#{gid}")
      session[:group_id] = gid
      @title = $redistopic.hget(gid,"title")
      talks = $rediscont.lrange gid, 0,-1
      cont = []
      num = 0
      talks.each do |content|
        msg = ActiveSupport::HashWithIndifferentAccess.new(eval(content))
        cont[num] = msg
        num = num + 1
      end
      gon.list = cont
    else 
      render :text => "そんなのないよ", :status => 404
    end
  end
  
  def main
    
  end

end
