class CreateShortUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :short_urls do |t|
      t.text :original_url
      t.string :shorted_url
      t.string :sanitize_url

      t.timestamps
    end

    add_index :short_urls, :shorted_url, unique: true
  end
end
