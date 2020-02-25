class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
