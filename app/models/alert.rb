class Alert < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  def send_alert
    require 'ruby_spark'

    device = RubySpark::Device.new("430034000f47343432313031", "34b551612fe36e083bacebc8e50dfa269acbb610")
    response = device.function("setAudio", "0")
    if response
      self.update(played: true)
    end
  end
end
