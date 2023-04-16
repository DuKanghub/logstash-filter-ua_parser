# encoding: utf-8
require 'spec_helper'
require "logstash/filters/ua_parser"

describe LogStash::Filters::UaParser do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        ua_parser {
          source => "http_user_agent"
          target => "ua"
        }
      }
    CONFIG
    end

    sample("message" => "some text") do
      expect(subject.get("message")).to eq('Hello World')
    end
  end
end
