require 'spec_helper'

describe MboxHeaderScraper::Scraper do
  pending '.process scrape mbox file and make output file.'

  describe '.analyze_single_mail' do
    context 'with simple mail file (simple.txt)' do
      it 'returns Subject at tsv format string' do
        input = File.open(File.expand_path('../../fixtures/simple.txt', __FILE__)).read
        options = { Subject: true }
        output = \
          "Plain\n"

        expect(MboxHeaderScraper::Scraper.analyze_single_mail(input, options)).to eq(output)
      end

      it 'returns To at tsv format string' do
        input = File.open(File.expand_path('../../fixtures/simple.txt', __FILE__)).read
        options = { To: true }
        output = \
          "hoge1@example.com\n" \
          "hige2@example.net\n" \
          "hoge3@example.net\n"

        expect(MboxHeaderScraper::Scraper.analyze_single_mail(input, options)).to eq(output)
      end

      it 'returns mail address in Body at tsv format string' do
        input = File.open(File.expand_path('../../fixtures/simple.txt', __FILE__)).read
        options = { Body: :mail_addresses }
        output = \
          "hugahuga1@example.com\n" \
          "hugahuga2@example.com\n" \
          "hugahuga3@example.com\n"

        expect(MboxHeaderScraper::Scraper.analyze_single_mail(input, options)).to eq(output)
      end

      it 'returns every value in options at tsv format string' do
        input = File.open(File.expand_path('../../fixtures/simple.txt', __FILE__)).read
        options = { Subject: true, Date: true, From: true, To: true, CC: true, Body: :mail_addresses }
        output = \
          "Plain\tFri, 15 May 2015 18:14:47 +0900\thugahuga@example.com\thoge1@example.com\tcc1@example.com\thugahuga1@example.com\n" \
          "\t\t\thige2@example.net\tcc2@example.com\thugahuga2@example.com\n" \
          "\t\t\thoge3@example.net\tcc3@example.com\thugahuga3@example.com\n" \
          "\t\t\t\tcc4@example.com\t\n" \

        expect(MboxHeaderScraper::Scraper.analyze_single_mail(input, options)).to eq(output)
      end
    end

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
