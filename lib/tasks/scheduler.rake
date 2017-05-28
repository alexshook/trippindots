desc "This task is called by the Heroku scheduler add-on"
task :delete_song_list => :environment do
  s3 = AWS::S3.new(
            :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
            :secret_access_key => ENV['AWS_SECRET_KEY_ID'])
  10.times do
    s3.buckets[ENV['S3_BUCKET_NAME_TD']].objects.each do |object|
      object.delete unless object.key == "by_the_way"
    end
  end
end
