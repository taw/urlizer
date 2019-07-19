class CreateShortcuts < ActiveRecord::Migration[6.0]
  def change
    create_table :shortcuts do |t|
      t.text :slug, unique: true
      t.text :target

      t.timestamps
    end
  end
end
