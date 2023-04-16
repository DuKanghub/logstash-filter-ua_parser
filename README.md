# logstash-filter-ua_parser

## 说明

这是一个基于ruby语言的`logstash filter`插件，用来解析`http_user_agent`，调用了外部库。

依赖以下库：

- user_agent_parser
- crawler_detect

## 开发环境测试

### 1. 插件开发环境和测试

#### Code

- 首先，您需要安装了Bundler gem的JRuby。
- 执行下面的命令安装依赖

```sh
bundle install
```

#### Test

- 安装依赖

```sh
bundle install
```

- 运行测试

```sh
bundle exec rspec
```

这里在windows可能执行失败，暂时没研究什么原因。

### 2. 在logstash中运行未发布的插件

以下方式2选一即可

#### 2.1 直接在logstash使用克隆下来的插件代码

进入logstash安装目录，一般是`/usr/share/logstash`

- 编辑 `Gemfile` ，添加本地插件路径，如下所示:

```ruby
gem "logstash-filter-ua_parser", :path => "/path/to/logstash-filter-ua-parser"
```

- 安装插件

```sh
bin/logstash-plugin install --no-verify
```

- 运行logstash测试此插件

```sh
cd /etc/logstash/conf.d
vim test.conf
# 添加如下内容
input {
   stdin {}
}
filter {
  ua_parser {
      source => "message"
  }
}
output {
  stdout { codec => rubydebug }
}
# 运行logstash
/usr/share/logstash/bin/logstash -f test.conf
```

然后在屏幕输入useragent就可以看到效果了。

#### 2.2 在logstash安装构建好的gem插件

- 构建gem

```sh
gem build logstash-filter-ua-parser.gemspec
```

- 进入logstash安装目录，安装gem插件

```sh
bin/logstash-plugin install /path/to/logstash-filter-ua_parser-0.0.1.gem
```

## 安装在线插件

```sh
bin/logstash-plugin install logstash-filter-ua_parser
```



