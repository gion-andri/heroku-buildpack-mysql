module Helpers
  MYSQL_CACHE_FILENAME = "mysql-client-core.deb"
  MYSQL_EXPECTED_PACKAGE = "mysql-community-client-core_8.4.3-1ubuntu24.04_amd64.deb"
  GOOD_MYSQL_RESPONSE = %{<tr><td><a href="#{MYSQL_EXPECTED_PACKAGE}">#{MYSQL_EXPECTED_PACKAGE}</a></td></tr>}
  BAD_MYSQL_RESPONSE = %{<tr><td><a href="mysql-client-core-5.5_5.5.47-0+deb7u1_ia64.deb">mysql-client-core-5.5_5.5.47-0+deb7u1_ia64.deb</a></td></tr>}

  def stub_request_to_base_url(base_url, response)
    stub_request(:get, base_url).
      with(:headers => {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'=>'repo.mysql.com',
        'User-Agent'=>'Ruby'}).
      to_return(
        :status => 200,
        :body => response,
        :headers => {})
  end

  def stub_request_for_expected_package(base_url, package)
    stub_request(:get, "#{base_url}#{package}").
      with(:headers => {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'=>'repo.mysql.com',
        'User-Agent'=>'Ruby'}).
      to_return(
        :status => 200,
        :body => "great job",
        :headers => {})
  end
end
