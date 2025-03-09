class AddSummaryAndTagsToDiaries < ActiveRecord::Migration[7.2]
  def change
    add_column :diaries, :summary, :string
    add_column :diaries, :tags, :string
    add_column :diaries, :mood_score, :integer
  end
end 