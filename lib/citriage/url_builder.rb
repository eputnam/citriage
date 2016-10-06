require 'curb'
require 'json'
require './lib/citriage/platforms'

class URLBuilder

  attr_accessor :base_url

  def initialize
    @base_url = "https://jenkins-modules.puppetlabs.com"
    @all_platforms = ['linux', 'windows', 'cross-platform', 'cloud', 'netdev']
  end

  def get_json url
    response = Curl.get(url + '/api/json')
    JSON.parse(response.body_str)
  end

  def platform_url platform
    case platform
    when "linux"
      _platform = "/view/2.%20linux%20only"
    when "windows"
      _platform = "/view/3.%20windows%20only"
    when "cross-platform"
      _platform = "/view/4.%20cross%20platform"
    when "cloud"
      _platform = "/view/5.%20cloud"
    when "netdev"
      _platform = "/view/6.%20netdev"
    end

    @base_url + _platform
  end

  def mod_platform mod
    Platforms.get.each do |platform|
      json = get_json(platform_url(platform))
      json['views'].each do |_mod|
        if _mod['name'] == mod
          return platform
          break
        end
      end
    end
  end

  def module_url mod
    platform_url(mod_platform(mod)) + "/view/#{mod}/view/#{mod}%20-%20master"
  end

  def get_job_list
    json = get_json(@base_url)

    modules_json = Hash.new

    json['jobs'].each do |job|
      if job['name'].start_with? "forge-module"
        modules_json
      end
    end
    puts modules_json
  end
end


puts URLBuilder.new.module_url "vcsrepo"
