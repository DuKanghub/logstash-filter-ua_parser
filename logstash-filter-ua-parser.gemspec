Gem::Specification.new do |s|
  s.name = 'logstash-filter-ua_parser'
  s.version         = '0.0.1'
  s.licenses = ['Apache-2.0']
  s.summary = "这是一个使用user_agent_parser解析useragent的logstash filter插件"
  s.description     = "这是一个使用user_agent_parser解析useragent的logstash filter插件"
  s.authors = ["dukanghub"]
  s.email = 'dukanghub@gmail.com'
  s.homepage = "https://github.com/Dukanghub/logstash-filter-ua_parser"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "user_agent_parser", "~> 2.15"
  s.add_runtime_dependency "crawler_detect", '~> 1.2', '>= 1.2.2'
  # ruby < 2.6 需要指定下面的qonfig版本重新构建，crawler_detect需要下面的包
  #s.add_runtime_dependency "qonfig", "0.26.0"
  s.add_development_dependency 'logstash-devutils'
end
