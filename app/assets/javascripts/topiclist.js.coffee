 class Callist
 
  constructor: (@list) ->
  
  #新着順
  sort_by: (sort)->
    compSort_By.call @,sort
 
  escape_html: (target) ->
    escape_by.call @,target

  compSort_By = (sortby) ->
    @list.sort (a,b) ->
      b[sortby] - a[sortby]
    return @

  escape_by = (target) ->
    $.each @list, (index,elem)->
      elem[target] =  elem[target].replace(/&/g, "&amp;")
                                  .replace(/"/g, "&quot;")
                                  .replace(/</g, "&lt;")
                                  .replace(/>/g, "&gt;")
    return @
  pubfunc:() ->
    @list

 class OutputList
  
  output_list:(raw) ->
    output_by_list.call @,raw

  output_by_list = (list) ->
    $("div.list-group").empty()
    $.each list, (index,value) ->
      top = "<a class='list-group-item' href='/topic/#{value[6]}' style='display:none'>
                  <div class='row'>
                    <div class='rowr imgdiv col-xs-2 col-md-2 col-sm-2'>"
      if value[5] isnt null
        url = value[5].replace(/\.(\w*)$/g,"m.$1")
        img =        "<img class='list_thumb' src='#{url}'>"
        top = top + img
      bottom ="     </div>
                    <div class='rowr col-xs-10 col-md-10 col-sm-10'>
                      <h4 class='overf list-group-item-heading'>#{value[0]}</h4>
                      <p class='list-group-item-text'><span class='text-primary'>open:</span><small>#{value[4]}</small>
                      <span class='text-primary'> last:</span><small>#{value[3]}<small></p>
                    </div>
                  </div>
            </a>"
      
      $("div.list-group").append "#{top}#{bottom}"
      $("a.list-group-item").show("slow")

 class UserModel

  constructor:(sortnum) ->
    @listm = new Callist(gon.list)
    @view = new OutputList()
    @cal(sortnum)

  cal: (target) =>
    @listm.sort_by(target).escape_html(0)
    @view.output_list(@listm.pubfunc())
  
 $ ->
  open = new UserModel(2)
  $("#pop").on 'click', ->
    open.cal(2)
    $(".tnav").attr('class','tnav')
    $(this).attr('class','tnav active')
  $("#new").on 'click', ->
    open.cal(4)
    $(".tnav").attr('class','tnav')
    $(this).attr('class','tnav active')
  $("#come").on 'click', ->
    open.cal(1)
    $(".tnav").attr('class','tnav')
    $(this).attr('class','tnav active')

