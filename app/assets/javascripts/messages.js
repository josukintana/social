/*
<% publish_to "/messages/new" do %>
  $("#chat").append("<%= j render(@message) %>");
  $("#new_message")[0].reset();
<% end %>
*/
$(document).ready(function(){
  // to create
  $("#link_add").click(function(){
    alert("Hola");
    $("#chat_div").chatbox({
                            id : "chat_div", title : "Title", user : "can be anything", offset: 200,
                            messageSent: function(id, user, msg){alert("DOM " + id + " just typed in " + msg);}
                          });
    // to insert a message
    //$("#chat_div").chatbox("option", "boxManager").addMsg("Mr. Foo", "Barrr!");
  });
});

