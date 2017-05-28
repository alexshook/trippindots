require 'rails_helper'

describe TrackAnalyzer do
  describe "SEARCH_BASE_URL" do
    it "is the spotify api base search url" do
      expect(TrackAnalyzer::SEARCH_BASE_URL).
        to eq("https://api.spotify.com/v1/search?q=")
    end
  end

  describe "TRACK_BASE_URL" do
    it "is the spotify api base track url" do
      expect(TrackAnalyzer::TRACK_BASE_URL).
        to eq("https://api.spotify.com/v1/tracks/")
    end
  end

  describe "AUDIO_ANALYSIS_BASE_URL" do 
    it "is the spotify api base search url" do
      expect(TrackAnalyzer::AUDIO_ANALYSIS_BASE_URL).
        to eq("https://api.spotify.com/v1/audio-analysis/")
    end
  end

  let(:analyzer)      { TrackAnalyzer.new(track_name, access_token) }
  let(:track_name)    { "by the way" }
  let(:access_token)  { "BQCDmGRKM2g7J83eiNbP4HghLqMiwAkWIUIRX9-qIbzshxLlAY_Jf7kWv9Odex0TxYIOXgw3-erNLxtF2MeY3w" } 

  describe "#run" do
    it "returns artist, track, and analysis" do
      VCR.use_cassette("track_analyzer_run") do
        expect(analyzer.run).to include(
          {
            artist: "Red Hot Chili Peppers",
            track: "By The Way",
            analysis: hash_including("meta")
          }
        )
      end
    end
  end

  describe "#spotify_track_id" do
    it "is the spotify track id" do
      VCR.use_cassette("spotify_track_id") do
        expect(analyzer.spotify_track_id).to eq("1f2V8U1BiWaC9aJWmpOARe")
      end
    end
  end
end
