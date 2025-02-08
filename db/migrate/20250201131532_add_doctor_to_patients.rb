class AddDoctorToPatients < ActiveRecord::Migration[7.1]
  def change
    add_reference :patients, :doctor, null: true, foreign_key: true
  end
end
