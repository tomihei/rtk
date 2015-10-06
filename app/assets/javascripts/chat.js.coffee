class @ChatClass
 constructor: (url, useWebsocket) ->
  group_id = $('#group_id').text()
  @dispatcher = new WebSocketRails(url, useWebsocket)
  @channel = @dispatcher.subscribe(group_id)
  console.log(url)
  idy = this
  @bindEvents(idy)
 
 
 bindEvents: (idy) =>
# 送信ボタンが押されたらサーバへメッセージを送信
  $('#send').on 'click', @sendMessage
  $('#chat').on 'click','button.resend',{test:idy}, @resendMessage

# サーバーからnew_messageを受け取ったらreceiveMessageを実行
  @channel.bind 'websocket_chat', @receiveMessage
  @dispatcher.bind 'websocket_chat', @receiveMessage
 sendMessage: (event) =>
# サーバ側にsend_messageのイベントを送信
# オブジェクトでデータを指定
  msg_body = $('#msgbody').val()
  group_id = $('#group_id').text()
  @channel.trigger 'websocket_chat', {  body: msg_body , group_id: group_id}
  $('#msgbody').val('')
 #返信用関数考えるのめんどかったからこれで 
 resendMessage: (event) ->
  #クリックした要素を参照
  resid = $(this).attr('id')
  msg_body = $("#msgbody#{resid}").val()
  group_id = $('#group_id').text()
  #ChatClassを参照  
  event.data.test.channel.trigger 'websocket_chat', {  body: msg_body , group_id: group_id , resid: resid}
  $("#msgbody#{resid}").val('')

 receiveMessage: (message) =>
  console.log message
  # 受け取ったデータをappend
  tbutton = $.cookie('treebutton')
  messagebody = @mescape(message.body,message.resnum)

  #共通部品
  newpost = "#{message.new}"
  if(newpost isnt "1")
    newlabel = "<span class='label label-warning' id='newlabel#{message.resnum}'>New</span>"
  else
    newlabel ="<span></span>"

  resnumAtime   = "<p><a name='ank#{message.resnum}'>#{message.resnum}</a>
                   <span class='badge' data-content='' data-title='#{message.resnum}への返信' id='rec#{message.resnum}'></span>
                   <small> #{message.time}</small> #{newlabel}"
  resnumAtimer  = "<p><a name='ank#{message.resnum}'>#{message.resnum}</a> 
                   <span class='badge' data-content='' data-title='#{message.resnum}への返信' id='rec#{message.resnum}'></span> 
                   <small> #{message.time}</small> #{newlabel}"
  footerm       = "<br>#{messagebody[0]} </p>
                   <div id='childpm#{message.resnum}'></div>
                   <div id='form#{message.resnum}' style='display: none'>
                   <form class='form-horizontal'>
                   <div class='form-group'>
                   <div class='textarea'>
                   <textarea  placeholder ='ここへ入力' wrap='hard' rows='3' id='msgbody#{message.resnum}' style='width:100%;'></textarea>
                   </div>
                   </div>
                   <button type='button' class='btn btn-default resend' id='#{message.resnum}' >送信</button>
                   </form>
                   </div>
                   <div id='child#{message.resnum}' class='contchild'></div>
                   </div>
                   "


  if(tbutton != 'on' )
    if(message.resid? isnt true)
     $('#chat').append "<div id='#{message.resnum}' class='contarea'>
                        #{resnumAtime}
                        <a class='res' id='#{message.resnum}'>返信</a>
                        #{footerm}"
    else
     $("div#child#{message.resid}").append "<div id='#{message.resnum}' class='contarea'>
                                       #{resnumAtime}
                                       <a class='res' id='#{message.resnum}'>返信</a>
                                       #{footerm}"
     @resinc($("span#rec#{message.resid}"),messagebody[0],message.resnum,message.time)
  else
    if(message.resid? isnt true)
      $('#chat').append "<div id='#{message.resnum}' class='contarea'>
                         #{resnumAtimer}
                         <a class='res' id='#{message.resnum}'>返信</a>
                         #{footerm}"
    else
     $("#chat").append "<div id='#{message.resnum}' class='contarea'>
                        #{resnumAtimer}
                        <a class='res' id='#{message.resnum}'>返信</a>
                        <br><a href='#ank#{message.resid}'>>>#{message.resid}</a>
                        #{footerm}"
     @resinc($("span#rec#{message.resid}"),messagebody[0],message.resnum,message.time)

  $("div#childpm#{message.resnum}").append "<div class='row'>
                                            <div class ='col-xs-10 col-md-10 col-sm-10'>
                                            <div id='pmrow#{message.resnum}'></div>
                                            </div>
                                            <div class='col-xs-2 col-md-2 col-sm-2'></div>
                                            </div>
                                            "
  vic = 0
  #gifv,webm以外のサムネイル
  if(messagebody[1] is 1)
   $("a#g#{message.resnum}").each ->
    pmurl = $(this).attr('href')
    vic++
    $("div#pmrow#{message.resnum}").append "<div class='span1'>
                                            <a id='gm#{message.resnum}#{vic}'class='gm#{message.resnum} thumbnail colgm' href='#{pmurl}'>
                                            <img id='lazy#{message.resnum}'class='lazy' data-original='#{pmurl}' width='50px' height='50px'>
                                            </a>
                                            </div>
                                            "
    if $.cookie('autopic') is 'on'
      $('img.lazy').lazyload()
    else
      $("img#lazy#{message.resnum}").lazyload
        event : "over"
      $("#gm#{message.resnum}#{vic}").on 'mouseover', ->
        $("img#lazy#{message.resnum}").trigger("over")
        $(this).attr 'name','on'
  else if(messagebody[1] is 0)
    #gifv,webmのサムネイル
   $("a#gw#{message.resnum}").each ->
    pmurl = $(this).attr('href')
    $("div#pmrow#{message.resnum}").append "<div class='span1'>
                                            <a class='thumbnail' href='#{pmurl}'>
                                            <img class='movie'>
                                            </a>
                                            </div>
                                            "
  else if(messagebody[1] is 2)
    #youtube,vimeo用この3つどうにかしろよ
   $("a#gy#{message.resnum}").each ->
    pmurl = $(this).attr('href')
    $("div#pmrow#{message.resnum}").append "<div class='span1'>
                                            <a id='movie#{message.resnum}' class='thumbnail' href='#{pmurl}'>
                                            <img class='movie'>
                                            </a>
                                            </div>
                                            "


  #Newラベル消去用
  if(newpost isnt "1")
   $("#newlabel#{message.resnum}").on 'inview', (event,isInView,visiblePartX,visiblePartY)->
     if(isInView == false)
      $(this).hide 'slow', ->
       $(this).remove()
  #オートスクロール用
   sclba = $("div##{message.resnum}").offset().top
   sclba = sclba - 50
   setTimeout ->
    $("html,body").animate({scrollTop:sclba})
   , 3000

  return 0
 #エスケープ処理
 mescape: (mbody,mnum) ->
    mbb =  mbody.replace(/&/g, "&amp;")
                .replace(/"/g, "&quot;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
    
    reg1 = /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(gifv|webm)/g
    reg2 = /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(jpg|jpeg|gif|png|bmp)/g
    reg3 = /https\:\/\/(www\.)?youtu(\.be|be)(\.com)?\/(watch\?v=)?([-\w]{11})/g

    pic  = reg1.test(mbody)
    pic2 = reg2.test(mbody)
    pic3 = reg3.test(mbody)

    if(pic is true)
      mba1 = mbb.replace(/(http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(gifv|webm))/g,"<a id='gw#{mnum}' href='$1'>$1</a><br>")
      mba2 = 0
      return [mba1,mba2]
    else if(pic2 is true)
      mba1 = mbb.replace(/(http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(jpg|jpeg|gif|png|bmp))/g,"<a id='g#{mnum}' href='$1'>$1</a><br>")
      mba2 = 1
      return [mba1,mba2]
    else if(pic3 is true)
      mba1 = mbb.replace(/(https\:\/\/(www\.)?youtu(\.be|be)(\.com)?\/(watch\?v=)?([-\w]{11}))/g,"<a id='gy#{mnum}' href='$1'>$1</a><br>")
      mba2 = 2
      return [mba1,mba2]
    else
      mba1 =mbb.replace(/(http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?)/,"<a href='$1'>$1</a>")
      mba2 = 3
      return [mba1,mba2]

 #返信数とツールチップ用関数 
 resinc: (incnum,mbody,mnum,mtime) ->
  
  #rescount
  
  rescount = parseInt(incnum.text(),0)
  if(isNaN(rescount))
    rescount = 0
  hres = rescount + 1
  if(hres is 1)
    incnum.attr 'class','badge'
  else if(hres > 1 and hres < 3)
    incnum.attr 'class','badge rescouBlo'
  else if(hres > 3)
    incnum.attr 'class','badge rescouRed'
  incnum.text(hres)
  
  #tooltip

  tip = incnum.attr 'data-content'
  tip = tip + "<a href='#ank#{mnum}'>#{mnum}</a>:#{mtime}<br>#{mbody}<br>"
  incnum.attr 'data-content',"#{tip}"
  

 $ ->
  
  #ボタンの状態判断用
  
  if($.cookie('treebutton') isnt 'on' )
    $('#tree').attr 'class','btn btn-default navbar-btn active'


  $('#tree').click ->
    $(this).button('toggle')
    if $.cookie('treebutton') isnt 'on'
     $.cookie('treebutton','on')
    else
     $.cookie('treebutton','off')
    location.reload()

  $('#autopic').click ->
    $(this).button('toggle')
    if $.cookie('autopic') isnt 'on'
      $.cookie('autopic','on')
    else
      $.cookie('autopic','off')
    location.reload()

  window.chatClass = new ChatClass($('#chat').data('uri'), true)

  
#返信フォーム用
  $('#chat').on 'click','a.res', ->
    resid = $(this).attr('id')
    $("div#form#{resid}").toggle(250)
 
  $('#chat').on 'click','a.colgm', ->
    iden = $(this).attr('class')
    idena = $(this).attr('id')
    $("a##{idena}").colorbox(
     rel:"#{iden}"
     maxWidth:"100%"
     maxHeight:"100%"
    )
  
  $(document).popover(
    html: true,
    selector:'.badge',
    content: ->
      $(this).attr('data-content')
  )





