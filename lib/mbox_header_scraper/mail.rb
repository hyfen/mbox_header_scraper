require 'nkf'

# mail object
class MboxHeaderScraper::Mail
  @mail = nil

  def initialize(mail_fp)
    @mail = mail_fp
  end

  # rubocop:disable Metrics/AbcSize
  def header_to_tsv(options)
    # TODO: prevent undefined options

    targets = get_target_keys(options)
    result = initialize_result_hash(targets)

    last_symbol = nil

    IO.foreach(@mail) do |line|
      line.chomp!

      # this must be continuous value of previous header
      if /^ / =~ line
        # use extract_email_address because Subjects and Dates can't be multiple line
        result[last_symbol].concat(extract_email_address(line.chomp)) if last_symbol

        next
      end

      targets.each do |param|
        matched = get_if_matched(param, line)

        if matched
          result[param].concat(matched) unless matched.empty?
          last_symbol = param
          break
        end

        last_symbol = nil
      end

      result = uniquify_result_hash(result)

      # mail header must finish with the first empty line
      return build_tsv(result, options) if /^$/ =~ line
    end

    # mail without empty line must be broken
    raise 'this mail is broken'
  end
  # rubocop:enable Metrics/AbcSize

  private

  def get_target_keys(options)
    options.select { |v| options[v] == true }.keys
  end

  def initialize_result_hash(targets)
    result = {}
    targets.each do |v|
      result[v] = []
    end

    result
  end

  def uniquify_result_hash(hash)
    hash.keys.each do |v|
      hash[v].uniq!
    end

    hash
  end

  def get_if_matched(param, line)
    return nil unless /^#{param}: / =~ line

    if param == :Subject
      subject = NKF.nkf('-mw', ($'))
      [subject.chomp]
    elsif param == :Date
      [($').chomp]
    else
      extract_email_address(($').chomp)
    end
  end

  def build_tsv(hash, options)
    targets = get_target_keys(options)

    tsv = ''

    i = 0
    loop do
      line = []
      targets.each do |v|
        line << (hash[v][i] || '')
      end

      break if line.all? { |v| v == '' }
      tsv += (line.join("\t") + "\n")
      i += 1
    end

    tsv
  end

  def extract_email_address(str)
    str.scan(/[0-9a-z.\+\-\_]+@[0-9a-z.\+\-\_]+/i)
  end
end
