# Command Interface
class MboxHeaderScraper::CLI < Thor
  desc \
    'mail_address_list {in file} {out file}',
    'load {in file} and output email address included to {out file}'
  long_desc \
    'load mbox file and output in tsv format file. ' \
    'the file includes No, Subject(short), From, To, CC'
  def mail_address_list(in_file, out_file)
    error_message = MboxHeaderScraper::Scraper.check_in_file(in_file)
    if error_message
      puts "input file error: #{error_message}"
      exit 1
    end

    error_message = MboxHeaderScraper::Scraper.check_out_file(out_file)
    if error_message
      puts "output file error: #{error_message}"
      exit 1
    end

    MboxHeaderScraper::Scraper.process(
      in_file,
      out_file,
      { Subject: true, Date: true, From: true, To: true, CC: true }
    )
  end
end
