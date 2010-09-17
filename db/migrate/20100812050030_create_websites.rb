class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :url
      t.string :clean_url
      t.integer :hits, :default => 0
      t.timestamps
    end

    add_index :websites, :clean_url, :unique => true
  end

  def self.down
    remove_index :websites, :clean_url

    drop_table :websites
  end
end
