class CreateMedicines < ActiveRecord::Migration[7.1]
  def change
    create_table :medicines do |t|
      t.string :name
      t.date :exp_date
      t.string :form
      t.string :manufacturer
      t.references :category, null: false, foreign_key: true
      t.string :batch_no
      t.boolean :prescribed

      t.timestamps
    end
  end
end
