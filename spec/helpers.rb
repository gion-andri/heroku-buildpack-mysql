module Helpers
  MYSQL_EXPECTED_PACKAGE = "mysql-client-core-8.0_8.0.34-0ubuntu0.20.04.1_amd64.deb"
  GOOD_MYSQL_RESPONSE =
    %{
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="mysql-client-core-8.0_8.0.19-0ubuntu5_amd64.deb">mysql-client-core-8.0_8.0.19-0ubuntu5_amd64.deb</a></td><td align="right">2022-01-01 05:15  </td><td align="right">1.6M</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="mysql-client-core-8.0_8.0.28-0ubuntu4_amd64.deb">mysql-client-core-8.0_8.0.28-0ubuntu4_amd64.deb</a></td><td align="right">2022-02-01 05:15  </td><td align="right">1.7M</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="mysql-client-core-8.0_8.0.32-0ubuntu4_amd64.deb">mysql-client-core-8.0_8.0.32-0ubuntu4_amd64.deb</a></td><td align="right">2022-03-01 05:15  </td><td align="right">1.8M</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="mysql-client-core-8.0_8.0.34-0ubuntu0.20.04.1_amd64.deb">mysql-client-core-8.0_8.0.34-0ubuntu0.20.04.1_amd64.deb</a></td><td align="right">2022-04-01 05:15  </td><td align="right">1.9M</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="mysql-client-core-8.0_8.0.34-1ubuntu1_amd64.deb">mysql-client-core-8.0_8.0.34-1ubuntu1_amd64.deb</a></td><td align="right">2022-05-01 05:15  </td><td align="right">2.0M</td></tr>
    }
  BAD_MYSQL_RESPONSE =
    %{
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="mysql-client-core-5.5_5.5.47-0+deb7u1_ia64.deb">mysql-client-core-5.5_5.5.47-0+deb7u1_ia64.deb</a></td><td align="right">2016-01-27 20:58  </td><td align="right">2.0M</td></tr>
    }

  LIBSSL_EXPECTED_PACKAGE = "libssl1.1_1.1.1f-1ubuntu2.19_amd64.udeb"
  GOOD_LIBSSL_RESPONSE =
    %{
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="libssl1.1-udeb_1.1.0g-2ubuntu4_amd64.udeb">libssl1.1-udeb_1.1.0g-2ubuntu4_amd64.udeb</a></td><td align="right">2018-04-25 19:04  </td><td align="right">141K</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="libssl1.1-udeb_1.1.1-1ubuntu2.1~18.04.23_amd64.udeb">libssl1.1-udeb_1.1.1-1ubuntu2.1~18.04.23_amd64.udeb</a></td><td align="right">2023-05-30 14:23  </td><td align="right">188K</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="libssl1.1-udeb_1.1.1f-1ubuntu2.19_amd64.udeb">libssl1.1-udeb_1.1.1f-1ubuntu2.19_amd64.udeb</a></td><td align="right">2023-05-30 14:23  </td><td align="right">186K</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="libssl1.1-udeb_1.1.1f-1ubuntu2_amd64.udeb">libssl1.1-udeb_1.1.1f-1ubuntu2_amd64.udeb</a></td><td align="right">2020-04-21 14:33  </td><td align="right">186K</td></tr>
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="libssl1.1_1.1.0g-2ubuntu4_amd64.deb">libssl1.1_1.1.0g-2ubuntu4_amd64.deb</a></td><td align="right">2018-04-25 19:04  </td><td align="right">1.1M</td></tr>
    }
  BAD_LIBSSL_RESPONSE =
    %{
    <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="libssl3.0_1.1.0g-2ubuntu4_amd64.deb">mysql-client-core-5.5_5.5.47-0+deb7u1_ia64.deb</a></td><td align="right">2016-01-27 20:58  </td><td align="right">2.0M</td></tr>
    }

  def stub_request_to_base_url(base_url, response)
    stub_request(:get, base_url).
      with(:headers => {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'=>'security.ubuntu.com',
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
        'Host'=>'security.ubuntu.com',
        'User-Agent'=>'Ruby'}).
      to_return(
        :status => 200,
        :body => "fake binary data",
        :headers => {})
  end
end
