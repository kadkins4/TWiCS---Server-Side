class CreatePhrases < ActiveRecord::Migration[5.1]
  def change
    create_table :phrases do |t|
      t.string :handle
      t.string :tweet
      t.datetime :created_on
    end
  end
end
