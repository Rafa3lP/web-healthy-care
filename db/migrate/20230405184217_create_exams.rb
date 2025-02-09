class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.references :patient, null: false, foreign_key: true
      t.integer :classification, null: false
      t.date :date, null: false
      t.string :local, null: false

      t.timestamps
    end
  end
end
