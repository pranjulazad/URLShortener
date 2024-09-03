# frozen_string_literal: true
class Validator::SiteValidator < ActiveModel::Validator
  def validate(record)
    validate_url(record)
  end

  def validate_url(record)
    if record.long_url.blank?
      record.errors.add(:url, "can't be blank")
      return
    end
    unless SiteHelper.valid_url?(record.long_url)
      record.errors.add(:url, "not acceptable")
    end
  end
end
