require 'net/http'

module BuildPack
  class Downloader
    MYSQL_BASE_URL = "http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/"
    # example: "mysql-client-core-8.0_8.0.22-0ubuntu0.20.04.1_amd64.deb"
    MYSQL_REGEX = /.*(mysql-client-core-8\.0_8\.0\.\d\d-0ubuntu0\.20\.\d\d\.\d_amd64.deb).*/

    LIBSSL1_1_BASE_URL = "http://security.ubuntu.com/ubuntu/pool/main/o/openssl/"
    # example: libssl1.1_1.1.0g-2ubuntu4_amd64.deb
    LIBSSL_REGEX = /.*(libssl1\.1_1\.1\.[0-9][a-z]-[0-9]ubuntu[0-9\.]+_amd64\.deb).*/

    class << self
      def download_mysql_to(path)
        Logger.log_header("Downloading MySQL Client package")
        mysql = most_recent_client(MYSQL_BASE_URL, MYSQL_REGEX)
        Logger.log("Selecting: #{mysql}")
        File.open(path, 'w+').write(Net::HTTP.get(URI.parse("#{MYSQL_BASE_URL}#{mysql}")))
      end

      def download_libssl_to(path)
        Logger.log_header("Downloading libssl 1.1 package")
        libssl = most_recent_client(LIBSSL1_1_BASE_URL, LIBSSL_REGEX)
        Logger.log("Selecting: #{libssl}")
        File.open(path, 'w+').write(Net::HTTP.get(URI.parse("#{LIBSSL1_1_BASE_URL}#{libssl}")))
      end

      def most_recent_client(base_url, latest_client_regex)
        Logger.log("Looking for clients at: #{base_url}")

        response = Net::HTTP.get(URI.parse("#{base_url}"))

        Logger.log("available clients:")
        most_recent = ""
        response.lines.each do |line|
          if latest_client_regex =~ line
            Logger.log("#{$1}")
            most_recent = $1 if $1 > most_recent
          end
        end

        if most_recent.empty?
          Logger.log("No suitable clients available. Failing buildpack.")
          exit 1
        end

        most_recent
      end
    end
  end
end
