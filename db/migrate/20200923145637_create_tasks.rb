# rails g model task title:string description:text done:boolean deadline:datetime user:references
# default false adicionado manualmente
class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :done, default: false
      t.datetime :deadline
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
