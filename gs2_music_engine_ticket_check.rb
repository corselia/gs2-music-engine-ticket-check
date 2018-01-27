require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

def session
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w(headless disable-gpu window-size=1920,1080) }
    )
    Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        desired_capabilities: capabilities
    )
  end

  Capybara.javascript_driver = :headless_chrome

  @session = Capybara::Session.new(:headless_chrome)
end

def check
  session

  gs2_music_engine_eplus_uri = 'http://sort.eplus.jp/sys/T1U14P0010163P0108P002247809P0050001P006001P0030001'
  @session.visit(gs2_music_engine_eplus_uri)

  doc = Nokogiri::HTML.parse(@session.html, nil, 'UTF-8')
  nodes = doc.xpath(%Q(//p[@class="accept-pre"]))
  nodes[0].text
end

check #=> "一般発売・予定枚数終了"
