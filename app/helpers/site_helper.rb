module SiteHelper
  def self.local_port?(url)
    parsed = URI.parse(url)
    [443,80].exclude? parsed.port
  rescue URI::InvalidURIError
    false
  end

  def self.valid_url?(url)
    return false unless url =~ /\A#{URI::regexp(['http', 'https'])}\z/
    return false if local_port?(url)
    return true
  end

  def self.get_uniq_hashcode
    secure_string = [*'a'..'z', *'A'..'Z', *0..9].shuffle(random: Random.new(SecureRandom.hex(23).to_i(16)))
    secure_string_enum = secure_string.permutation(7)
    secure_string_enum.next.join
  end
end
