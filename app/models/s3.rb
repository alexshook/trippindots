class S3
  BUCKET_NAME = ENV['S3_BUCKET_NAME_TD']

  attr_reader :songfile

  def initialize(songfile = nil)
    @songfile = songfile
  end

  def tracks_list
    s3.list_objects(bucket: BUCKET_NAME).first.contents
  end

  def upload_track
    response        = create_multipart_upload
    upload_response = upload_part(response.upload_id)
    complete_multipart_upload(response.upload_id, upload_response.etag)
  end

  private

  def create_multipart_upload
    s3.create_multipart_upload({
      acl: "public-read",
      bucket: BUCKET_NAME,
      key: key,
    })
  end

  def upload_part(upload_id)
    s3.upload_part({
      body: songfile.tempfile,
      bucket: BUCKET_NAME,
      content_length: 1,
      key: key,
      part_number: 1,
      upload_id: upload_id
    })
  end

  def complete_multipart_upload(upload_id, etag)
    s3.complete_multipart_upload({
      bucket: BUCKET_NAME,
      key: key,
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

  def key
    sanitize_filename(songfile.original_filename.strip.downcase)
  end

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/, '_')
  end

  def s3
    @s3 ||= begin
      Aws::S3::Client.new(
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_KEY_ID']
      )
    end
  end
end
