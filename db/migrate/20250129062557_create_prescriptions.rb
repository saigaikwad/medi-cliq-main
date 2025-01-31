class CreatePrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :prescriptions do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.references :medicine, null: false, foreign_key: true
      t.text :dosage_description
      t.integer :prescription_quantity
      t.integer :duration
      t.boolean :status

      t.timestamps
    end
  end
end
