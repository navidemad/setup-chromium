require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem "rails"
  gem "sqlite3", platform: "ruby"
  gem "rspec-rails"
  gem "capybara"
  gem "cuprite", github: "rubycdp/cuprite"
  gem "debug"
  gem "puma"
end

require "action_controller/railtie"

class App < Rails::Application
  config.load_defaults Rails::VERSION::STRING.to_f
  config.root = __dir__
  config.consider_all_requests_local = true
  config.eager_load = false
  config.logger = Logger.new($stdout)
  Rails.logger = config.logger
  routes.draw do
    root to: "pages#home"
  end
end

class PagesController < ActionController::Base
  include Rails.application.routes.url_helpers

  def home
    render html: %(<html><body>Hello World</body></html>).html_safe
  end
end

require "minitest/autorun"
require "capybara"
require "capybara/rails"
require "capybara/dsl"
require "capybara/cuprite"

Capybara.register_driver(:custom_cuprite) do |app|
  browser_options =
    {}.tap do |opts|
      opts["allow-insecure-localhost"] = nil
      opts["ignore-certificate-errors"] = nil
      opts["disable-web-security"] = nil
      opts["disable-site-isolation-trials"] = nil
      opts["disable-features"] = "IsolateOrigins,DialMediaRouteProvider,MediaRouter"
      opts["remote-allow-origins"] = "*"
      opts["no-sandbox"] = nil if ENV["CI"]
    end

  options =
    {}.tap do |opts|
      browser_headfull = ENV.fetch("WITH_BROWSER", false).in?(%w[y 1 yes true])
      opts[:browser_options] = browser_options
      opts[:js_errors] = true
      opts[:window_size] = [600, 400]
      opts[:headless] = browser_headfull ? false : "new"
      opts[:inspector] = browser_headfull ? true : false
      opts[:url_blacklist] = [/\.ico$/]
      opts[:browser_path] = ENV["CHROMIUM_BIN"] if ENV["CHROMIUM_BIN"].present?
    end

  driver = Capybara::Cuprite::Driver.new(app, options)
  process = driver.browser.process
  puts "Browser: #{process.browser_version}"
  puts "Protocol: #{process.protocol_version}"
  puts "V8: #{process.v8_version}"
  puts "Webkit: #{process.webkit_version}"
  driver
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.default_driver = :custom_cuprite
  config.javascript_driver = :custom_cuprite
end

class HomeTest < Minitest::Test
  include Capybara::DSL

  def test_home
    visit "/"
    assert_text "Hello World"
  end

  private

  def app
    Rails.application
  end
end
