class AddIndexToSiteUrls < ActiveRecord::Migration[7.1]
  def change
    add_index :site_urls, :hash_code, :unique => true
  end
end
