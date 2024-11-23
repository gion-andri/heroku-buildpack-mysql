require 'spec_helper'

TMP_DIR = "tmp"
CACHE_DIR = "#{TMP_DIR}/cache_dir"
BUILD_DIR = "#{TMP_DIR}/build_dir"
DPKG_BIN_DIR = "#{BUILD_DIR}/tmp/mysql-client-core/usr/bin"
DPKG_BIN_OUTPUT = "#{DPKG_BIN_DIR}/mysql"
MYSQLDUMP_BIN_OUTPUT = "#{DPKG_BIN_DIR}/mysqldump"
MYSQL_INSTALLED_BINARY = "#{BUILD_DIR}/bin/mysql"
MYSQLDUMP_INSTALLED_BINARY = "#{BUILD_DIR}/bin/mysqldump"
EXPECTED_MYSQL_DEB_COMMAND = "dpkg -x #{CACHE_DIR}/#{Helpers::MYSQL_CACHE_FILENAME} #{BUILD_DIR}/tmp/mysql-client-core"
STUBBED_MYSQL_DEB_COMMAND = "mkdir -p #{DPKG_BIN_DIR}; touch #{DPKG_BIN_OUTPUT}; touch #{MYSQLDUMP_BIN_OUTPUT}"

describe BuildPack::Installer do
  before { `mkdir -p #{TMP_DIR} #{CACHE_DIR} #{BUILD_DIR}` }
  after { `rm -rf #{TMP_DIR}` }

  context "when cache already has client" do
    before { `touch #{CACHE_DIR}/#{Helpers::MYSQL_CACHE_FILENAME}` }

    it "installs cached client" do
      expect(described_class).to receive(:`).
        with(EXPECTED_MYSQL_DEB_COMMAND).
        and_return(`#{STUBBED_MYSQL_DEB_COMMAND}`)

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exist?(MYSQL_INSTALLED_BINARY)).to be true
      expect(File.executable?(MYSQL_INSTALLED_BINARY)).to be true
      expect(File.exist?(MYSQLDUMP_INSTALLED_BINARY)).to be true
      expect(File.executable?(MYSQLDUMP_INSTALLED_BINARY)).to be true
    end
  end

  context "when cache does not have client" do
    before(:each) do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::GOOD_MYSQL_RESPONSE)
    end

    it "downloads and installs available client" do
      stub_request_for_expected_package(
        BuildPack::Downloader::MYSQL_BASE_URL,
        Helpers::MYSQL_EXPECTED_PACKAGE
      )

      expect(described_class).to receive(:`).
        with(EXPECTED_MYSQL_DEB_COMMAND).
        and_return(`#{STUBBED_MYSQL_DEB_COMMAND}`)

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exist?(MYSQL_INSTALLED_BINARY)).to be true
      expect(File.executable?(MYSQL_INSTALLED_BINARY)).to be true
      expect(File.exist?(MYSQLDUMP_INSTALLED_BINARY)).to be true
      expect(File.executable?(MYSQLDUMP_INSTALLED_BINARY)).to be true
    end

    it "raises an error when no compatible clients are available" do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::BAD_MYSQL_RESPONSE)

      expect {
        BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)
      }.to raise_error

      expect(File.exist?(MYSQL_INSTALLED_BINARY)).to be false
      expect(File.exist?(MYSQLDUMP_INSTALLED_BINARY)).to be false
      expect(Dir.exist?("#{BUILD_DIR}/tmp/mysql-client-core")).to be false
    end
  end
end
