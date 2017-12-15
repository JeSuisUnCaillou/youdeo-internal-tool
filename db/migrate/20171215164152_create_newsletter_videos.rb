class CreateNewsletterVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :newsletter_videos do |t|
      t.string :playlist_id
      t.string :video_id
      t.string :video_title
      t.string :video_thumbnail
      t.string :channel_title
      t.string :channel_desc
      t.string :new_title
      t.string :new_desc

      t.timestamps
    end
  end
end
