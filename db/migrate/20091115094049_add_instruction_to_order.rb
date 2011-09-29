class AddInstructionToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :customer_instruction, :string
  end

  def self.down
    remove_column :orders, :customer_instruction
  end
end
