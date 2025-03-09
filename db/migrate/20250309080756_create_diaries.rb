class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.text :content
      t.text :positive_content

      t.timestamps
    end
  end
end
