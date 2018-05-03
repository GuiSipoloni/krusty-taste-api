class CreatePreparationSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :preparation_steps do |t|
      t.numeric :step
      t.text :description
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
