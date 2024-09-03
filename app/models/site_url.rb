class SiteUrl < ApplicationRecord
  validates_with Validator::SiteValidator
end
