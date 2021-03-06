#
# Copyright 2012-2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'libxml2'
default_version '2.9.4'

license 'MIT'
license_file 'COPYING'

dependency 'zlib'
dependency 'libiconv'
dependency 'liblzma'
dependency 'config_guess'

version '2.9.4' do
  source md5: 'ae249165c173b1ff386ee8ad676815f5'
end

source url: "ftp://xmlsoft.org/libxml2/libxml2-#{version}.tar.gz"

relative_path "libxml2-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "--with-zlib=#{install_dir}/embedded",
    "--with-iconv=#{install_dir}/embedded",
    '--without-python',
    '--without-icu'
  ]

  # solaris 10 ipv6 support is broken due to no inet_ntop() in -lnsl
  configure_command << '--enable-ipv6=no' if solaris_10?

  update_config_guess

  configure(*configure_command, env: env)

  make "-j #{workers}", env: env
  make 'install', env: env
end
