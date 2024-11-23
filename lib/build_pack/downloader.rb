require 'net/http'

module BuildPack
  class Downloader
    MYSQL_BASE_URL = "http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.4/"
    # example: "mysql-client_8.4.3-0ubuntu1_amd64.deb"
    MYSQL_REGEX = /.*(mysql-client_8\.4\.\d+-0ubuntu\d+_amd64\.deb).*/

    class << self
      def download_mysql_to(path)
        Logger.log_header("Downloading MySQL Client package")
        mysql = most_recent_client(MYSQL_BASE_URL, MYSQL_REGEX)
        Logger.log("Selecting: #{mysql}")
        File.open(path, 'w+').write(Net::HTTP.get(URI.parse("#{MYSQL_BASE_URL}#{mysql}")))
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
