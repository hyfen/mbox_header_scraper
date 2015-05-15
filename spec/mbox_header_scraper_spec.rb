require 'spec_helper'

describe MboxHeaderScraper do
  it 'has a version number' do
    expect(MboxHeaderScraper::VERSION).not_to be nil
  end

  describe MboxHeaderScraper::Scraper do
    pending '.check_in_file checks if the file is suitable to process.'
    pending '.check_out_file checks if the file can be created as output file.'
  end
end
