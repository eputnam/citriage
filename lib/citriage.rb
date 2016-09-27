require 'curb'
require 'json'
require 'rainbow/ext/string'

class Citriage

  def initialize
    @base_url = "https://jenkins-modules.puppetlabs.com/view"
  end

  def get_json url
    _url = "#{url}/api/json"

    # puts "url: #{_url}"
    JSON.parse(Curl.get(_url).body_str)
  end

  def platform_url platform
    case platform
    when "linux"
      _platform = "/2.%20linux%20only"
    when "windows"
      _platform = "/3.%20windows%20only"
    when "cross-platform"
      _platform = "/4.%20cross%20platform"
    end

    _platform
  end

  def assemble_module_list platform

    _platform = platform_url platform

    list_json = get_json "#{@base_url}#{_platform}"

    module_list = Array.new

    list_json['views'].each do |module_name|
      module_list.push module_name["name"]
    end

    module_list
  end

  def generate_url platform, module_name, branch_name

    _platform = "#{platform_url platform}/view"
    _module_name = "/#{module_name}/view"
    branch_name = "/#{module_name}%20-%20#{branch_name}/"

    url = @base_url + _platform + _module_name + branch_name
    # puts "generated url: #{url}"
    url
  end

  def list_jobs json
    mod_status = true
    failed_job = String.new
    json['jobs'].each do |job|
      if job['color'] == 'red'
        mod_status = false
        failed_job = job['name']
        break
      else
        mod_status = true
      end
    end
    print json['name'].split(" ")[0]
    if mod_status
      puts " \u2713".color(:green)
    else
      puts " \u2715 FAILURE: #{failed_job}".color(:red)
    end
  end

  def run
    platforms = ["windows", "linux", "cross-platform"]

    platforms.each do |platform|
      puts "#{platform.upcase}".color(:cyan)
      begin
        modules = assemble_module_list platform

        modules.each do |mod|
          unless mod == "ad hoc" or mod == "websphere_application_server"
            json = get_json(generate_url platform,mod,"master")
            list_jobs json
          end
        end
      rescue
        puts "rescued"
      end
    end
  end
end


