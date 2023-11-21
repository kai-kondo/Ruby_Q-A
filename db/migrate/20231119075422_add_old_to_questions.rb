class AddOldToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :old, :integer
  end
end
