# mail object
class MboxHeaderScraper::Mail
  @mail = nil

  def initialize(mail_fp)
    @mail = mail_fp
  end

  def header_to_tsv(options)
    options ||= { Subject: true, From: true, To: true, CC: true }
  end
end
