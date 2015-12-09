class TopicAddPagesController < ApplicationController
  def mainpage
    render :layout => 'addpage'
  end

  def senddata
    
   toptitle = params[:title]
   content = params[:content]
   imgurl = params[:imgurl]
   hashkey = Time.zone.now.strftime("%Y%m%d%H%M%S%N").to_i.to_s(36)
   puts hashkey
   #データの検証
   @pres = Topicvalid.new(permit_params)
   if @pres.valid?
    now = Time.now.to_i   
    Topic.create(key: hashkey)
    cid = Time.zone.now.strftime("%d%H%M%S%N").to_i.to_s(36)
    ntime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    dig = request.remote_ip.to_i * Time.zone.now.strftime("%d").to_i
    client_id = Digest::SHA1.hexdigest(dig.to_s).to_i(16).to_s(36)
    message = {"body"=> content,"group_id"=> hashkey,"time"=>ntime,"imgurl"=>imgurl,"comment_id" => cid,"client_id" => client_id}
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

  private

  def permit_params
    params.permit(:title,:content,:imgurl)
  end
end
