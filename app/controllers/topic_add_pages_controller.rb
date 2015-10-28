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
    Topic.create(key: hashkey) 
    ntime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    message = {"body"=> content,"group_id"=> hashkey,"resnum"=>1,"time"=>ntime}
    #トピックデータを追加
    $redistopic.mapped_hmset(hashkey, {"title" => toptitle,"rescount"=> 1, "visitor"=> 0, "lastpost"=> now,"buildtime" => now})
    #最初の投稿を追加
    $rediscont.rpush hashkey,message
    redirect_to "/topic/#{hashkey}"
   else
    flash.now[:error] ='無効なデータです'
    render "mainpage"
   end
  end

  def topiclist
   session[:main] = "on"
   allkey = Topic.select("key")
   @list = {} 
   allkey.each do |topic|
    #トピックデータ取り出し配列形式
    @list["#{topic[:key]}"] = $redistopic.hmget("#{topic[:key]}","title","rescount","visitor","lastpost","buildtime")
    cont = $rediscont.lpop topic[:key] 
    @list["#{topic[:key]}"].insert(5,cont)
   end
  end
end
