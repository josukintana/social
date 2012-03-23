class MessagesController < ApplicationController
  
  def index
    @messages = Message.all
  end
  
  def create
    @message = Message.create!(params[:message])
    #PrivatePub.publish_to("/messages/new", "alert('#{@message.content}');")
    #render :js do
    #  jQuery('#messages').append render @message
    #  jQuery('#new_message_text').val 'hola' #if @message.user_id == current_user_id
    #end
    #publish_to @message.channel do
    #jQuery('#messages').append render @message
    #jQuery('#new_message_text').val '' #if @message.user_id == current_user_id
    #end
  end

  
end

