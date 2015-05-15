require 'spec_helper'

describe MboxHeaderScraper do
  it 'has a version number' do
    expect(MboxHeaderScraper::VERSION).not_to be nil
  end

  describe MboxHeaderScraper::Scraper do
    pending '.process scrape mbox file and make output file.'

    describe '.analyze_single_mail' do
      it 'returns tsv format string with simple mail file'
      it 'returns tsv format string with html mail file'
      it 'returns tsv format string with utf-8 mail file'
      it 'returns tsv format string with file attached mail file'
      it 'returns empty string with mail file if nothing discovered'
    end

    describe '.check_in_file' do
      it 'returns error message if file does not exists' do
        allow(File).to receive(:exist?).and_return(false)
        expect(MboxHeaderScraper::Scraper.check_in_file('sample')).to eq('file does not exists.')
      end

      it 'returns nil if file exists' do
        allow(File).to receive(:exist?).and_return(true)
        expect(MboxHeaderScraper::Scraper.check_in_file('sample')).to be_nil
      end
    end

    describe '.check_out_file' do
      it 'returns nil if file does not exists' do
        allow(File).to receive(:exist?).and_return(false)
        expect(MboxHeaderScraper::Scraper.check_out_file('sample')).to be_nil
      end

      it 'returns error message if file exists' do
        allow(File).to receive(:exist?).and_return(true)
        expect(MboxHeaderScraper::Scraper.check_out_file('sample')).to eq('file already exists.')
      end
    end
  end
end
