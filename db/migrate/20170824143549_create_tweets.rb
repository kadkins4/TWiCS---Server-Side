class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :handle
      t.string :content
      t.datetime :created_on
    end
  end
end
