require 'curb'
require 'json'
require 'rainbow/ext/string'
require 'commander'
require "citriage/version"
require 'citriage/platforms'
require 'citriage/url_builder'

class Citriage
  include Commander::Methods

  attr_accessor :base_url

  def initialize
    @base_url = "https://jenkins-modules.puppetlabs.com/view"
    @url = URLBuilder.new
  end

  def assemble_module_list platform

    list_json = @url.get_json @url.platform_url(platform)
    module_list = Array.new

    list_json['views'].each do |_module|
      module_list.push _module["name"]
    end

    module_list
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
    program :version, Version::VERSION
    program :description, 'CLI tool for Modules CI Triage'

    command :all do |c|
      c.syntax = 'ci-triage all'
      c.description = 'Lists all modules at the top level.'
      c.option '--platform STRING', String, 'Platform(s) to display.'
      c.action do |args, opts|
        if opts.platform
          platforms = opts.platform.split(',')
        else
          platforms = Platforms.get
        end

        platforms.each do |platform|
          puts "#{platform.upcase}".color(:cyan)
          modules = assemble_module_list platform

          modules.each do |mod|
            unless mod == "ad hoc"
              json = @url.get_json(@url.module_url mod)
              list_jobs json
            end
          end
        end
      end
    end

    command :module do |c|
      c.syntax = 'ci-triage module'
      c.description = 'Lists all jobs in a module.'
      c.action do |args, opts|
        mod = args
        puts mod
      end
    end
    default_command :all

    run!
  end
end
