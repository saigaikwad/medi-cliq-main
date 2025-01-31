class CreateQrs < ActiveRecord::Migration[7.1]
  def change
    create_table :qrs do |t|
      t.references :prescription, null: false, foreign_key: true
      t.text :qr_code

      t.timestamps
    end
  end
end
