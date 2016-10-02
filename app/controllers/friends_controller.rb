class FriendsController < ApplicationController
  before_action :set_friend, only: :destroy

  def index
    @friends = current_user.friends(&:email)
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
          @users = User.search(params[:search]).map(&:email)
      else
          @users = User.all.map(&:email)
      end

  # def upload_alert
  #   alert = Alert.new(from_id: current_user.id, to_id: params[:id], url: "meh")
  #   # bucket = AWS::S3.new.buckets["pickyroosterbucket"]
  #   # key = "#{current_user.id}_#{params[:id]}_#{Time.now}"

  #   # obj = bucket.objects[key]
  #   # obj.write(
  #   #   file: params[:file],
  #   #   acl: :public_read
  #   # )

  #   # alert = Alert.new(
  #   #   from_id: current_user.id,
  #   #   to_id: params[:id],
  #   #   url: obj.public_url
  #   # )
  #   if alert.save
  #     flash[:success] = "Alert uploaded!"
  #     redirect_to action: 'show', id: params[:id]
  #   else
  #     flash.now[:notice] = 'There was an error'
  #     render action: 'show', id: params[:id]
  #   end
  # end

  # def send_alert
  #   count = 0
  #   Alert.where(played: false).each do | alert |
  #     if alert.send_alert
  #       count += 1
  #     end
  #   end
  #   flash[:success] = "Sent #{count} alerts!"
  #   redirect_to action: 'show', id: params[:id]
  # end

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
        "https://api.particle.io/v1/devices/430034000f47343432313031/setAudio?access_token=34b551612fe36e083bacebc8e50dfa269acbb610",
       {args: stringify(pcm[(offset * batch_size)..((offset + 1) * batch_size)])})
      puts response.code
      puts stringify(pcm[(offset * batch_size)..((offset + 1) * batch_size)])
    end
    response = RestClient.post(
        "https://api.particle.io/v1/devices/430034000f47343432313031/setAudio?access_token=34b551612fe36e083bacebc8e50dfa269acbb610",
       {args: 999})


  end

  def stringify(pcm)
    pcm.map{|str| " " + str}.join(" ")
  end

end
