class S3
  BUCKET_NAME = ENV["S3_BUCKET_NAME_TD"]

  attr_reader :file, :track_name

  def initialize(options = {})
    @file       = options[:songfile]
    @track_name = sanitize(options[:track_name])
  end

  def tracks_list
    s3.list_objects(bucket: BUCKET_NAME).first.contents
  end

  def upload_track
    response        = create_multipart_upload
    upload_response = upload_part(response.upload_id)
    complete_multipart_upload(response.upload_id, upload_response.etag)
  end

  def file
    "https://s3.amazonaws.com/#{BUCKET_NAME}/#{track_name}"
  end

  private

  def create_multipart_upload
    s3.create_multipart_upload({
      acl: "public-read",
      bucket: BUCKET_NAME,
      key: track_name,
    })
  end

  def upload_part(upload_id)
    s3.upload_part({
      body: file.tempfile,
      bucket: BUCKET_NAME,
      content_length: 1,
      key: track_name,
      part_number: 1,
      upload_id: upload_id
    })
  end

  def complete_multipart_upload(upload_id, etag)
    s3.complete_multipart_upload({
      bucket: BUCKET_NAME,
      key: track_name,
      multipart_upload: {
        parts: [
          {
            etag: etag,
            part_number: 1,
          }
        ]
      },
      upload_id: upload_id
    })
  end

  def sanitize(name)
    return unless name
    name.strip.downcase.gsub(/[^\w\.\-]/, "_")
  end

  def s3
    @s3 ||= begin
      Aws::S3::Client.new(
        :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
        :secret_access_key => ENV["AWS_SECRET_KEY_ID"]
      )
    end
  end
end
