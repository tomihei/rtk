  
 $ ->
   $preview = $('img.image-preview')
   $file = $('input#file-selector')
   $file.on 'change', ->
     $("img.loading").show("normal")
     [file] = $file.get(0).files
     fr = new FileReader
     fr.readAsBinaryString(file)
     fr.onload = (event) =>
       pic = window.btoa(event.target.result)
       $.ajax({
        url: "https://api.imgur.com/3/image",
        headers: {
          'Authorization': 'Client-ID 2f91e49e1313411'
        },
        type:"POST",
        data: {
          type:"base64"
          image:pic
          }
        }).done (page)->
          $("img.loading").hide("normal")
          $preview.attr src:page.data.link, width:250
          
