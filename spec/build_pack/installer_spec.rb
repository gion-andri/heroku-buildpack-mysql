require 'spec_helper'

TMP_DIR = "tmp"
CACHE_DIR = "#{TMP_DIR}/cache_dir"
BUILD_DIR = "#{TMP_DIR}/build_dir"
DPKG_BIN_DIR = "#{BUILD_DIR}/tmp/mysql-client-core/usr/bin"
DPKG_BIN_OUTPUT = "#{DPKG_BIN_DIR}/mysql"
MYSQL_INSTALLED_BINARY = "#{BUILD_DIR}/bin/mysql"
EXPECTED_MYSQL_DEB_COMMAND = "dpkg -x #{CACHE_DIR}/mysql-client-core.deb #{BUILD_DIR}/tmp/mysql-client-core"
STUBBED_MYSQL_DEB_COMMAND = "mkdir -p #{DPKG_BIN_DIR}; touch #{DPKG_BIN_OUTPUT}"

LIBSSL_DEB_OUTPUT = "#{BUILD_DIR}/tmp/libssl/usr/lib/x86_64-linux-gnu/libssl.so.1.1"
EXPECTED_LIBSSL_DEB_COMMAND = "dpkg -x #{CACHE_DIR}/libssl1.1.deb #{BUILD_DIR}/tmp/libssl"
STUBBED_LIBSSL_DEB_COMMAND = "mkdir -p #{DPKG_BIN_DIR}; touch #{LIBSSL_DEB_OUTPUT}"

describe BuildPack::Installer do
  before{`mkdir #{TMP_DIR}`}
  before{`mkdir #{CACHE_DIR}`}
  before{`mkdir #{BUILD_DIR}`}
  after{`rm -r #{TMP_DIR}`}

  context "when cache already has client" do
    before{`touch #{CACHE_DIR}/mysql-client-core.deb`}
    before{`touch #{CACHE_DIR}/libssl1.1.deb`}

    it "installs cached client" do
      expect(described_class).to receive(:`).with(EXPECTED_MYSQL_DEB_COMMAND).and_return(`#{STUBBED_MYSQL_DEB_COMMAND}`)
      expect(described_class).to receive(:`).with(EXPECTED_LIBSSL_DEB_COMMAND).and_return(`#{STUBBED_LIBSSL_DEB_COMMAND}`)

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).to be
    end
  end

  context "when cache does not have client " do
    before(:each) do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::GOOD_MYSQL_RESPONSE)
      stub_request_to_base_url(BuildPack::Downloader::LIBSSL1_1_BASE_URL, Helpers::GOOD_LIBSSL_RESPONSE)
    end

    it "downloads and installs available client" do
      stub_request_for_expected_package(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::MYSQL_EXPECTED_PACKAGE)
      stub_request_for_expected_package(BuildPack::Downloader::LIBSSL1_1_BASE_URL, Helpers::LIBSSL_EXPECTED_PACKAGE)
      expect(described_class).to receive(:`).with(EXPECTED_MYSQL_DEB_COMMAND) { `#{STUBBED_MYSQL_DEB_COMMAND}` }
      expect(described_class).to receive(:`).with(EXPECTED_LIBSSL_DEB_COMMAND).and_return(`#{STUBBED_LIBSSL_DEB_COMMAND}`)

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).to be
    end

    it "it does not attempt to install when there are no available clients" do
      stub_request_to_base_url(BuildPack::Downloader::MYSQL_BASE_URL, Helpers::BAD_MYSQL_RESPONSE)

      expect{BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)}.to raise_error(SystemExit)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).not_to be
    end

  end
end
