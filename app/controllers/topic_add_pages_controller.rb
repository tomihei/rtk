class TopicAddPagesController < ApplicationController
  def mainpage
    render :layout => 'addpage'
  end

  def senddata
    
   toptitle = params[:title]
   content = params[:content]
   imgurl = params[:imgurl]
   hashkey = Time.now.to_i / (rand(20)+1)
   puts hashkey
   #データの検証
   @pres = Topicvalid.new :title => toptitle, :content => content, :imgurl => imgurl
   if @pres.valid?
    now = Time.now.to_i   
    Topic.create(key: hashkey) 
    ntime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    message = {"body"=> content,"group_id"=> hashkey,"time"=>ntime,"imgurl"=>imgurl}
    #トピックデータを追加
    $redistopic.mapped_hmset(hashkey, {"title" => toptitle,"rescount"=> 1, "visitor"=> 0, "lastpost"=> ntime,"buildtime" => now,"imgurl" => imgurl})
    #最初の投稿を追加
    $rediscont.rpush hashkey,message
    cookies[:build] = hashkey
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
   @listary = []
   num = 0
   allkey.each do |topic|
    #トピックデータ取り出し配列形式
    @list["#{topic[:key]}"] = $redistopic.hmget("#{topic[:key]}","title","rescount","visitor","lastpost","buildtime","imgurl")
    @listary[num] = @list["#{topic[:key]}"]
    @listary[num].push("#{topic[:key]}")
    num = num + 1
   end
   gon.list = @listary
  end
end
