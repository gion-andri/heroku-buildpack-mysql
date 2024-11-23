require 'spec_helper'

describe BuildPack::Downloader do
  context "when there are several packages available" do
    it "picks the most recent amd64 package" do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::GOOD_MYSQL_RESPONSE)
      expect(BuildPack::Downloader.most_recent_client(
        BuildPack::Downloader::MYSQL_BASE_URL,
        BuildPack::Downloader::MYSQL_REGEX)
      ).to eql(Helpers::MYSQL_EXPECTED_PACKAGE)
    end

    it "ignores non-ubuntu24 packages" do
      mixed_response = %{
        <tr><td><a href="mysql-community-client-core_8.4.3-1ubuntu22.04_amd64.deb">mysql-community-client-core_8.4.3-1ubuntu22.04_amd64.deb</a></td></tr>
        <tr><td><a href="mysql-community-client-core_8.4.2-1ubuntu24.04_amd64.deb">mysql-community-client-core_8.4.2-1ubuntu24.04_amd64.deb</a></td></tr>
        <tr><td><a href="mysql-community-client-core_8.4.3-1ubuntu24.10_amd64.deb">mysql-community-client-core_8.4.3-1ubuntu24.10_amd64.deb</a></td></tr>
      }

      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, mixed_response)
      expect(BuildPack::Downloader.most_recent_client(
        BuildPack::Downloader::MYSQL_BASE_URL,
        BuildPack::Downloader::MYSQL_REGEX)
      ).to eql("mysql-community-client-core_8.4.3-1ubuntu24.10_amd64.deb")
    end
  end

  context "when no compatible packages are available" do
    it "exits with error" do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::BAD_MYSQL_RESPONSE)
      expect {
        BuildPack::Downloader.most_recent_client(
          BuildPack::Downloader::MYSQL_BASE_URL,
          BuildPack::Downloader::MYSQL_REGEX
        )
      }.to raise_error(SystemExit)
    end
  end
end
