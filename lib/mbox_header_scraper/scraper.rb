# scrape mbox file
class MboxHeaderScraper::Scraper
  # rubocop:disable Metrics/AbcSize
  def self.process(in_file, out_file, options = { Subject: true, Date: true, From: true, To: true, CC: true })
    Tempfile.open('mbox_header_scraper_result') do |result_file|
      result_file.write(insert_header(options))

      tmp = nil

      # to prevent nil error on first line
      def tmp.closed?
        true
      end

      IO.foreach(in_file) do |line|
        # encode to convert invalid charcter
        enc_line = line.encode("UTF-16BE", "UTF-8",
           invalid: :replace,
           undef: :replace,
           replace: '?').encode("UTF-8")
           
        if /^From / =~ enc_line && !tmp.closed?
          tmp.close(false)
          result_file.write(single_mail_to_tsv(tmp, options))
          tmp.delete
        end

        tmp = Tempfile.open('mbox_header_scraper_tmp') if tmp.closed?
        tmp.write(enc_line)
      end

      tmp.close(false)
      result_file.write(single_mail_to_tsv(tmp, options))
      tmp.delete

      result_file.close(false)
      FileUtils.copy_file(result_file.path, out_file)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def self.check_in_file(filename)
    return 'file does not exists.' unless File.exist?(filename)
    nil
  end

  def self.check_out_file(filename)
    return 'file already exists.' if File.exist?(filename)
    nil
  end

  def self.single_mail_to_tsv(mail_file, options)
    mail = MboxHeaderScraper::Mail.new(mail_file)
    mail.header_to_tsv(options)
  end

  def self.insert_header(headers)
    line = []

    headers.select { |v| headers[v] == true }.keys.each do |v|
      line << v
    end

    (line.join("\t") + "\n")
  end
end
