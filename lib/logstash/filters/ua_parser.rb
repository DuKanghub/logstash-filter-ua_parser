# encoding: utf-8
require "logstash/filters/base"
require "user_agent_parser"
require 'crawler_detect'

class LogStash::Filters::UaParser < LogStash::Filters::Base
  config_name "ua_parser"

  # 用户代理字符串的字段名，默认为 "user_agent"
  config :source, :validate => :string, :default => "http_user_agent"
  config :target, :validate => :string, :default => "ua"

  public
  def register
    # Nothing to do here
  end

  public
  def filter(event)
    # 获取用户代理字符串
    useragent = event.get(@source)
    return if useragent.nil? || !useragent.is_a?(String) || useragent.strip == ""

    # 将用户代理字符串传递给 UserAgent 解析器
    begin
      data = UserAgentParser.parse useragent
    rescue StandardError => e
      @logger.error("Uknown error while parsing device data", :exception => e, :field => @source, :event => event)
      return
    end
    return unless data
    # Remove original source (if its also the target)
    event.remove(@source) if @target == @source

    # 提取系统和浏览器信息
    begin
      # is_mobile = false
      # mozilla = false
      # model = true
      is_bot = false
      spider = ""
      platform = "Other"
      # os_full = "Other"
      # engine = ""
      # engine_version = ""
      browser = ""
      browser_version = ""
      # browser_full = ""
      os_name = ""
      os_version = ""
      device_name = ""
      device_brand = ""
      if data.family
        browser = data.family.to_s
      end
      if data.version
        browser_version = data.version.to_s
      end
      # if data.to_s
      #   browser_full = data.to_s
      # end
      # if data.os
      #   os_full = data.os.to_s
      # end
      if data.os
        os = data.os.to_s
        os_arr = os.split(" ")
        os_name = os_arr.at(0)
        if os_arr.length > 1
          os_version = os_arr.at(1)
        end
      end
      if data.device
        device_brand = data.device.brand.to_s
        device_name = data.device.to_s
        platform = data.device.model.to_s
      end
      bot = CrawlerDetect.new(useragent)
      if bot.is_crawler?
        is_bot = true
        spider = bot.crawler_name
      end
      target_hash = {
        "browser" => {
          "name" => browser,
          "version" => browser_version
        },
        "os" => {
          "name" => os_name,
          "version" => os_version
        },
        "device" => {
          "name" => device_name,
          "brand" => device_brand,
          "type" => platform
        },
        "isBot" => is_bot
      }
      if is_bot
        target_hash['botName'] = spider
      end
      event.set("#{@target}", target_hash)
    rescue StandardError => e
      @logger.error("Uknown error while setting device data", :exception => e, :field => @source, :event => event)
      return
    end

    # 过滤器处理完成后，将事件返回
    filter_matched(event)
  end


end