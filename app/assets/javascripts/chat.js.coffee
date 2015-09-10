class @ChatClass
 constructor: (url, useWebsocket) ->
  group_id = $('#group_id').text()
  document.cookie = "gidi = #{group_id}"
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
  if(message.resid? isnt true)
   $('#chat').append "<div id='#{message.resnum}' class='contarea'><p>#{message.resnum} <small> #{message.time}</small> <a class='res' id='#{message.resnum}'>返信</a>
                    <br>#{message.body} </p><div id='child#{message.resnum}'></div></div>"
  else
   $("div##{message.resid}").append "<div id='#{message.resnum}' class='contarea'><p>#{message.resnum} <small> #{message.time}</small> <a class='res' id='#{message.resnum}'>返信</a>
                      <br>#{message.body} </p><div id='child#{message.resnum}'></div></div>"


 $ ->
  window.chatClass = new ChatClass($('#chat').data('uri'), true)
#返信用フォーム追加用
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
  
  
