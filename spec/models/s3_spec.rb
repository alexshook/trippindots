require 'rails_helper'

describe S3 do
  describe "BUCKET_NAME" do
    it "is the bucket name where the tracks are stored" do
      expect(S3::BUCKET_NAME).to eq("trippindots")
    end
  end

  describe "#tracks_list" do
    context "when it has two tracks" do
      it "is is 2" do
        VCR.use_cassette("list_tracks") do
          expect(S3.new.tracks_list.size).to eq(2)
        end
      end
    end
  end
end
