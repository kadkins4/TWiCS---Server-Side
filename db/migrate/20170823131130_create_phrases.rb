class CreatePhrases < ActiveRecord::Migration[5.1]
  def change
    create_table :phrases do |t|
      t.string :content
      t.datetime :created_on
    end
  end
end
