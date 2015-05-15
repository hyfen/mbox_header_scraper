# Command Interface
class MboxHeaderScraper::CLI < Thor
  desc \
    'mail_address_list {in file} {out file}',
    'load {in file} and output email address included to {out file}'
  long_desc \
    'load mbox file and output in tsv format file. ' \
    'the file includes No, Subject(short), From, To, CC, Body(email address only)'
  def mail_address_list(in_file, out_file)
  end
end
