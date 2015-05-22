require 'spec_helper'

describe MboxHeaderScraper::Mail do
  describe '.header_to_tsv' do
    context 'with simple mail file (simple.txt)' do
      it 'returns Subject at tsv format string' do
        input = File.expand_path('../../fixtures/simple.txt', __FILE__)
        options = { Subject: true }
        output = \
          "Plain\n"

        mail = MboxHeaderScraper::Mail.new(input)
        expect(mail.header_to_tsv(options)).to eq(output)
      end

      it 'returns To at tsv format string' do
        input = File.expand_path('../../fixtures/simple.txt', __FILE__)
        options = { To: true }
        output = \
          "hoge1@example.com\n" \
          "hige2@example.net\n" \
          "hoge3@example.net\n"

        mail = MboxHeaderScraper::Mail.new(input)
        expect(mail.header_to_tsv(options)).to eq(output)
      end

      it 'returns every value in options at tsv format string' do
        input = File.expand_path('../../fixtures/simple.txt', __FILE__)
        options = { Subject: true, Date: true, From: true, To: true, CC: true }
        output = \
          "Plain\tFri, 15 May 2015 18:14:47 +0900\thugahuga@example.com\thoge1@example.com\tcc1@example.com\n" \
          "\t\t\thige2@example.net\tcc2@example.com\n" \
          "\t\t\thoge3@example.net\tcc3@example.com\n" \
          "\t\t\t\tcc4@example.com\n" \

        mail = MboxHeaderScraper::Mail.new(input)
        expect(mail.header_to_tsv(options)).to eq(output)
      end
    end

    it 'returns tsv format string with html mail file'
    it 'returns tsv format string with utf-8 mail file'
    it 'returns tsv format string with file attached mail file'
    it 'returns empty string with mail file if nothing discovered'
  end

  describe '.extract_email_address' do
    before :all do
      @mail = MboxHeaderScraper::Mail.new('')
    end

    it 'returns mail address for normal email address' do
      expect(@mail.send(:extract_email_address, \
                        'hogehoge@example.net')).to eq(['hogehoge@example.net'])
      expect(@mail.send(:extract_email_address, \
                        '<hogehoge@example.net>')).to eq(['hogehoge@example.net'])
      expect(@mail.send(:extract_email_address, \
                        'テスト太郎 <hogehoge@example.net>')).to eq(['hogehoge@example.net'])
    end

    it 'returns mail address for email address with hyphen' do
      expect(@mail.send(:extract_email_address, \
                        'hoge-hoge@ex-ample.net')).to eq(['hoge-hoge@ex-ample.net'])
    end

    it 'returns mail address for email address with underscore' do
      expect(@mail.send(:extract_email_address, \
                        'hoge_hoge@ex_ample.net')).to eq(['hoge_hoge@ex_ample.net'])
    end

    it 'returns all mail addresses for multiple email address' do
      expect(@mail.send(:extract_email_address, \
                        'hoge@example.net,fuga@test.com')).to eq(['hoge@example.net', 'fuga@test.com'])
    end

    it 'returns empty string for invalid email address' do
      expect(@mail.send(:extract_email_address, \
                        'abcdefghijk')).to eq([])
    end
  end
end
