class ChangeLastCommentTime < ActiveRecord::Migration
  def up
    change_column(:forum_posts, :last_comment_time, :datetime, :null => true)
  end

  def down
    change_column(:forum_posts, :last_comment_time, :datetime, :null => false)
  end
end
