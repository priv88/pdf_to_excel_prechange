class TaskMailer < ActionMailer::Base
  default :from => ENV['GMAIL']

  def send_nasdaq_email
    @receiver_email = 'amy.privco@gmail.com'
    @receiver_name = 'Norval'
    
    file_name = "Nasdaq " + Time.now.strftime('%m-%d-%Y') + ".xls"
    file_path = "#{Rails.root}/Nasdaq.xls"
    mail.attachments[file_name] = {:content => File.read(file_path, :mode => 'rb'), :transfer_encoding => :binary}
    
    mail(:to => @receiver_email, :subject => "Nasdaq Monthly Updates")
  end
end