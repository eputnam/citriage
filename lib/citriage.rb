require 'curb'
require 'json'
require 'rainbow/ext/string'
require 'commander'
require "citriage/version"

module Citriage
  class Citriage
    include Commander::Methods

    attr_accessor :base_url

    def initialize
      @base_url = "https://jenkins-modules.puppetlabs.com/view"
    end

    def api_url url
      "#{url}/api/json"
    end

    def get_json url
      _url = api_url url

      response = Curl.get(_url) do |curl|
        curl.on_failure { |failure| puts "cURL failed for #{failure.url}" }
      end

      begin
        JSON.parse(response.body_str)
      rescue JSON::ParserError
        puts "There was a problem parsing the JSON for #{_url}".color(:red)
      end

    end

    def platform_dir platform
      case platform
      when "linux"
        _platform = "/2.%20linux%20only"
      when "windows"
        _platform = "/3.%20windows%20only"
      when "cross-platform"
        _platform = "/4.%20cross%20platform"
      when "cloud"
        _platform = "/5.%20cloud"
      when "netdev"
        _platform = "/6.%20netdev"
      end
      _platform
    end

    def assemble_module_list platform
      _platform = platform_dir platform

      list_json = get_json "#{@base_url}#{_platform}"
      module_list = Array.new

      list_json['views'].each do |_module|
        module_list.push _module["name"]
      end

      module_list
    end

    def generate_url platform, module_name, branch_name
      _platform = "#{platform_dir platform}/view"
      _module_name = "/#{module_name}/view"
      branch_name = "/#{module_name}%20-%20#{branch_name}/"

      @base_url + _platform + _module_name + branch_name
    end

    def list_jobs json
      mod_status = true
      failed_job = String.new
      begin
        json['jobs'].each do |job|
          if job['color'] == 'red'
            mod_status = false
            failed_job = job['url']
            break
          else
            mod_status = true
          end
        end
        if mod_status
          print "\u25CF ".color(:green)
          puts json['name'].split(" ")[0]
        else
          print "\u25CF ".color(:red)
          print json['name'].split(" ")[0]
          puts " FAILURE: #{failed_job}".color(:red)
        end
      rescue NoMethodError
        puts "Got an empty list for a module."
      end
    end

    def run
      program :name, 'ci-triage'
      program :version, Citriage::VERSION
      program :description, 'CLI tool for Modules CI Triage'

      command :all do |c|
        c.syntax = 'ci-triage all'
        c.description = 'Lists all modules at the top level.'
        c.option '--platform STRING', String, 'Platform(s) to display.'
        c.action do |args, opts|
          if opts.platform.size > 0
            platforms = opts.platform.split(',')
          else
            platforms = ["windows", "linux", "cross-platform", "cloud", "netdev"]
          end

          platforms.each do |platform|
            puts "#{platform.upcase}".color(:cyan)
            modules = assemble_module_list platform

            modules.each do |mod|
              unless mod == "ad hoc"
                json = get_json(generate_url platform,mod,"master")
                list_jobs json
              end
            end
          end
        end
      end

      default_command :all

      run!
    end
  end
end
