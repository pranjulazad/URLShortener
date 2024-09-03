class CreateSiteUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :site_urls do |t|
      t.text :long_url, :null => false
      t.string :hash_code, :null => false, :limit => 7
      t.timestamps null: false
    end
  end
end
