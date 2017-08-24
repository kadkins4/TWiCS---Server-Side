class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.string :picture_url
        t.string :tags
        t.datetime :created_on
        t.references :tweets
    end
  end
end
