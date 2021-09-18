class CreateRetweets < ActiveRecord::Migration[5.2]
  def change
    create_table :retweets do |t|

      t.timestamps
    end
  end
end