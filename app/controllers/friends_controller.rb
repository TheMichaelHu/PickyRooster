class FriendsController < ApplicationController
  before_action :set_friend, only: :destroy

  def index
    @friends = current_user.friends
  end

  def show
    @friend = User.find(params[:id])
  end

  def destroy
    current_user.remove_friend(@friend)
    head :no_content
  end

  def search
      @users = User.all

      if params[:search]
          @users = User.search(params[:search])
      else
          @users = User.all
      end
  end

  def send_alert
    data = params[:url]
    audio_data=Base64.decode64(data['data:audio/ogg;base64,'.length .. -1])
    pcm = audio_data.split("").map do |char| "%3d" % [char.ord ] end

    actually_send_the_alert(pcm)

    flash[:success] = "Alert sent!"
    redirect_to action: 'show', id: params[:id]
  end

  private

  def set_friend
    @friend = current_user.friends.find(params[:id])
  end

  def actually_send_the_alert(pcm)
    require 'rest-client'
    batch_size = 10
    # (pcm.length/batch_size).times do | offset |
    5.times do | offset |  
      response = RestClient.post(
        "https://api.particle.io/v1/devices/430034000f47343432313031/setaudio?access_token=34b551612fe36e083bacebc8e50dfa269acbb610",
       {args: stringify(pcm[(offset * batch_size)..((offset + 1) * batch_size)])})
      puts response.code
      puts stringify(pcm[(offset * batch_size)..((offset + 1) * batch_size)])
    end
    response = RestClient.post(
        "https://api.particle.io/v1/devices/430034000f47343432313031/setaudio?access_token=34b551612fe36e083bacebc8e50dfa269acbb610",
       {args: " 999"})
  end

  def stringify(pcm)
    pcm.map{|str| " " + str}.join(" ")
  end

end
