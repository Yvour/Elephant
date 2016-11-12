class CreateMediators < ActiveRecord::Migration[5.0]
  def change
    create_table :mediators do |t|

      t.timestamps
    end
  end
end
