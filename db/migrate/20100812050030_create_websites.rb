class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :url
      t.string :clean_url
      t.timestamps
    end

    add_index :websites, :url
  end

  def self.down
    remove_index :websites, :url

    drop_table :websites
  end
end
