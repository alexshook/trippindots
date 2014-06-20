class AmazonSong
  def self.delete_all
    AWS::S3::Bucket.find(ENV['S3_BUCKET_NAME_TD']).objects.each do |object|
      object.delete
    end
  end
end
