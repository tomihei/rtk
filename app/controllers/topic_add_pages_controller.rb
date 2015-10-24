class TopicAddPagesController < ApplicationController
  def mainpage
  end

  def senddata
    
   toptitle = params[:title]
   content = params[:content]
   hashkey = Time.now.to_i / (rand(20)+1)
   puts hashkey
   #データの検証
   @pres = Topicvalid.new :title => toptitle, :content => content
   if @pres.valid?
    now = Time.now.to_i   
    Topic.create(key: hashkey,title: toptitle) 
    ntime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    message = {"body"=> content,"group_id"=> hashkey,"resnum"=>1,"time"=>ntime}
    #トピックデータを追加
    $redistopic.mapped_hmset(hashkey, {"rescount"=> 0, "visitor"=> 0, "lastpost"=> now})
    #最初の投稿を追加
    $rediscont.rpush hashkey,message
    redirect_to "/topic/#{hashkey}"
   else
    flash.now[:error] ='無効なデータです'
    render "mainpage"
   end
  end

  def topiclist
   allkey = Topic.select("key,title")
   @list = {}
   allkey.each do |topic|
    @list["#{topic[:key]}"]= $redistopic.hgetall topic
    @list["#{topic[:key]}"] = {"title" => "#{topic[:title]}"}
   end

  end
end
