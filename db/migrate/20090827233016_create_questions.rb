class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :question, :limit => 30
      t.string :answer, :limit => 30
      t.references :user
      t.references :product

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
