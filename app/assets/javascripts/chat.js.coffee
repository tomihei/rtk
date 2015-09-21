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
  message.body = @mescape(message.body,message.resnum)

  #共通部品
  resnumAtime   = "<p>#{message.resnum} 
                   <small> #{message.time}</small>"
  resnumAtimer  = "<p><a name='ank#{message.resnum}'>#{message.resnum}</a> 
                   <small> #{message.time}</small>"
  footerm       = "<br>#{message.body} </p>
                   <div id='childpm#{message.resnum}'></div>
                   <div id='child#{message.resnum}'></div>
                   </div>"


  if(tbutton % 2 isnt 1 )
    if(message.resid? isnt true)
     $('#chat').append "<div id='#{message.resnum}' class='contarea'>
                        #{resnumAtime}
                        <a class='res' id='#{message.resnum}'>返信</a>
                        #{footerm}"
    else
     $("div##{message.resid}").append "<div id='#{message.resnum}' class='contarea contchild'>
                                       #{resnumAtime}
                                       <a class='res' id='#{message.resnum}'>返信</a>
                                       #{footerm}"
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
  
  $("a.g#{message.resnum}").each ->
   pmurl = $(this).attr('href')
   $("div#childpm#{message.resnum}").append "
                                             <a class='gm#{message.resnum}' href='#{pmurl}'>
                                             <img class='lazy' data-original='#{pmurl}' width='5%' height='5%'>
                                             </a>
                                             "
    
  $("a.gm#{message.resnum}").colorbox(
     rel:"gm#{message.resnum}"
     maxWidth:"100%"
     maxHeight:"100%"
  )

  $('img.lazy').lazyload()

 #エスケープ処理
 mescape: (mbody,mnum) ->
    mbody.replace(/&/g, "&amp;")
         .replace(/"/g, "&quot;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         #  .replace(/(http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?)/,"<a href='$1'>$1</a>")
    
    reg = /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(jpg|jpeg|gif|png|bmp|gifv|webm)/g

    pic = reg.test(mbody)

    if(pic is true)
      console.log "a"
      mbody.replace(/(http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(jpg|jpeg|gif|png|bmp|gifv|webm))/g,"<a class='g#{mnum}' href='$1'>$1</a><br>")
 
    else
      mbody.replace(/(http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?)/,"<a href='$1'>$1</a>")
    


 $ ->
  
  buttonum = 0
  $('#treebutton').on 'click', ->
    if($.cookie('treebutton'))
      buttonum = $.cookie('treebutton')
    buttonum++
    $.cookie('treebutton',buttonum)
    location.reload()

  window.chatClass = new ChatClass($('#chat').data('uri'), true)


#返信フォーム用
  $('#chat').on 'click','a.res', ->
   resid = $(this).attr('id')
   aldform = $(this).attr('name')
   resop = "open#{resid}"
   console.log aldform
   console.log resid
   if(aldform isnt resop )
    $(this).attr('name',"open#{resid}")
    $("div#child#{resid}").append " 
     <form class='form-horizontal'>
      <div class='form-group'>
      <input type='hidden' name='resid' value='#{resid}'>
        <div class='textarea'>
          <textarea  placeholder ='ここへ入力' wrap='hard' rows='3' id='msgbody#{resid}' style='width:100%;'></textarea>
        </div>
      </div>
      <button type='button' class='btn btn-default resend' id='#{resid}' >送信</button>
     </form>"
  
  
