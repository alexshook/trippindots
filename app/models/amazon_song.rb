class AmazonSong
  def self.delete_all
    10.times do
      AWS::S3::Bucket.find(ENV['S3_BUCKET_NAME_TD']).objects.each do |object|
        object.delete unless object.key == "01_By The Way.mp3"
      end
    end
  end
end
