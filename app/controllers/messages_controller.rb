class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user)
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    if @message.save
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user)
      render :index
    end
  end

  # このクラスでしか呼び出せないメソッド(private)
  private
  # サーバーの外部から、リクエストに含まれてきた情報を格納したものとは「def params end」
  def message_params
    # 送信されたパラメーターの情報を持つparamsから、どの情報を取得したいか指定「params.require」
    # 取得したい情報から、指定したキーとセットになる値のみ取得「params.require(:モデル名).permit(:キー名)」 
    # ハッシュを結合させる「merge」
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end
end