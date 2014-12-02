class TaskMailer < ActionMailer::Base
  default :from => ENV['GMAIL']

  def send_nasdaq_email(type)
    @receiver_email = 'amy.privco@gmail.com'
    @receiver_email_2 = 'norval.privco@gmail.com'
    @receiver_name = 'Norval'
    type = type

    if type = "filings"
      file_name = "Nasdaq " + Time.now.strftime('%m-%d-%Y') + ".xls"
      file_path = "#{Rails.root}/Nasdaq_Filings.xls"
    else
      file_name = "Nasdaq " + Time.now.strftime('%m-%d-%Y') + ".xls"
      file_path = "#{Rails.root}/Nasdaq_Withdrawn.xls"
    end

    mail.attachments[file_name] = {:content => File.read(file_path, :mode => 'rb'), :transfer_encoding => :binary}
    mail(:to => @receiver_email_2, :cc => @receiver_email, :subject => "Nasdaq Monthly Updates #{type}")
  end





end