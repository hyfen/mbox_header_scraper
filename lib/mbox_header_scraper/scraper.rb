# scrap mbox file
class MboxHeaderScraper::Scraper
  def self.process(in_file, out_file, options = nil)
  end

  def self.check_in_file(filename)
    return 'file does not exists.' unless File.exist?(filename)
    nil
  end

  def self.check_out_file(filename)
    return 'file already exists.' if File.exist?(filename)
    nil
  end

  def self.analyze_single_mail(mail, options)
    options ||= { Subject: true, From: true, To: true, CC: true }
  end
end
