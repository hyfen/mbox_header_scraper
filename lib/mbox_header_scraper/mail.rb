require 'mail'

# mail object
class MboxHeaderScraper::Mail
  @mail = nil

  def initialize(mail_fp)
    @mail = Mail.read(mail_fp)
  end

  def analyze_single_mail(options)
    options ||= { Subject: true, From: true, To: true, CC: true }
    @mail.subject
  end
end
