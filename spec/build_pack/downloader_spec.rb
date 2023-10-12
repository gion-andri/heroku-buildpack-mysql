require 'spec_helper'

describe BuildPack::Downloader do
  context "when there are several packages available" do
    it "picks the most recent amd64 package" do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::GOOD_MYSQL_RESPONSE)
      expect(BuildPack::Downloader.most_recent_client(
        BuildPack::Downloader::MYSQL_BASE_URL,
        BuildPack::Downloader::MYSQL_REGEX)
      ).to eql("#{Helpers::MYSQL_EXPECTED_PACKAGE}")
    end
  end
end
