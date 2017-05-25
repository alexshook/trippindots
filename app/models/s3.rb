class S3
  BUCKET_NAME = ENV['S3_BUCKET_NAME_TD']

  def tracks_list
    s3.list_objects(bucket: BUCKET_NAME).first.contents
  end

  private

  def s3
    @s3 ||= begin
      Aws::S3::Client.new(
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_KEY_ID']
      )
    end
  end
end
