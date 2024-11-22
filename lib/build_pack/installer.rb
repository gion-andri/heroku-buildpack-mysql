require 'fileutils'

module BuildPack
  class Installer
    class << self

      def install(build_dir, cache_dir)
        init_paths(build_dir, cache_dir)
        make_dirs
        install_mysql
        install_libssl
        cleanup
      end

      private

      def init_paths(build_dir, cache_dir)
        @bin_path = "#{build_dir}/bin"
        @tmp_path = "#{build_dir}/tmp"
        @mysql_path = "#{@tmp_path}/mysql-client-core"
        @mysql_binaries = "#{@mysql_path}/usr/bin"
        @mysql_pkg = "#{cache_dir}/mysql-client-core.deb"
        @libssl_path = "#{@tmp_path}/libssl"
        @libssl_pkg = "#{cache_dir}/libssl1.1.deb"
      end

      def make_dirs
        FileUtils.mkdir_p(@bin_path)
        FileUtils.mkdir_p(@tmp_path)
        FileUtils.mkdir_p(File.dirname(@mysql_pkg))
      end

      def client_exists?
        if File.exist?(@mysql_pkg)
          Logger.log_header("Using MySQL Client package from cache")
          return true
        end
        false
      end

      def libssl_exists?
        if File.exist?(@libssl_pkg)
          Logger.log_header("Using libssl package from cache")
          return true
        end
        false
      end

      def install_mysql
        Downloader.download_mysql_to(@mysql_pkg) unless client_exists?
        # Extract mysql client
        run_command_with_message(command: "dpkg -x #{@mysql_pkg} #{@mysql_path}", message: "Installing MySQL Client")

        fix_perms_and_mv_binaries
      end

      def install_libssl
        Downloader.download_libssl_to(@libssl_pkg) unless libssl_exists?
        # The heroku-22 stack ships with openssl 3.0 instead of 1.1 but the mysql client
        # is linked against 1.1. This is a workaround until the mysql client is updated to 8.1
        run_command_with_message(command: "dpkg -x #{@libssl_pkg} #{@libssl_path}", message: "Extracting libssl")
      end

      def run_command_with_message(command:, message:)
        Logger.log_header("#{message}")
        Logger.log("#{command}")
        output = `#{command}`
        puts output
      end

      def fix_perms_and_mv_binaries
        # TODO: Doing a glob for some reason causes issues on heroku-16,
        #       erroring out as it can't find the files to chmod and mv.
        #       Specifying `mysqldump` specifically for now. Otherwise use:
        # ```
        # binaries = Dir.glob("#{@mysql_binaries}/*")
        # ```
        mysql_binary = Dir.glob("#{@mysql_binaries}/mysql")
        FileUtils.chmod("u=wrx", mysql_binary)
        FileUtils.mv(mysql_binary, @bin_path)

        mysqldump_binary = Dir.glob("#{@mysql_binaries}/mysqldump")
        FileUtils.chmod("u=wrx", mysqldump_binary)
        FileUtils.mv(mysqldump_binary, @bin_path)
      end

      def cleanup
        Logger.log_header("Cleaning up")
        # Don't remove libssl directory as it's needed at runtime
        FileUtils.remove_dir(@mysql_path)
      end
    end
  end
end
