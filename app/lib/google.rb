require "bundler/setup"
require "date"
require "fileutils"
require "erb"
require 'googleauth'
require 'googleauth/stores/file_token_store'
require "google/apis/calendar_v3"

class GoogleCalendar

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = "amazon-history-calendar".freeze
  CLIENT_SECRET = "./config/client_secret.json".freeze
  TOKEN_STORE_FILE = "./config/credentials.yaml".freeze

  def initialize
    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRET)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_STORE_FILE)
    scope = Google::Apis::CalendarV3::AUTH_CALENDAR
    @authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    @credentials = @authorizer.get_credentials('default')
    @service = service if !@credentials.nil?
  end

  # ※初回のみ実行。ブラウザでURLを開き承認する。credentials.yamlが作成される。 
  #  Execute only the first time.Open the URL in the browser and approve it. credentials.yaml is created.
  def authorize
    url = @authorizer.get_authorization_url(base_url: OOB_URI)
    puts "OAuth2.0同意画面(#{url}) の承認結果を入力してください:"
    code = gets
    @credentials = @authorizer.get_and_store_credentials_from_code(user_id: 'default', code: code, base_url: OOB_URI)
    @service = service if @credentials.nil?
  end

  # 指定されたカレンダーにイベントを作成する
  # Create an event in the specified calendar
  def insert_event(row)
    erb = ERB.new(File.read("./templates/purchase_history.html.erb"))
    @product_url = row[:product_url]
    @product_name = row[:product_name]
    @order_number = row[:order_number]
    @order_summary_url = row[:order_summary_url]
    @order_date = row[:order_date]
    @price = row[:price]
    @quantity = row[:quantity]
    body = erb.result(binding)

    calendar_id = "jagasorutomatai@gmail.com"
    product_name = row[:product_name]
    start_time = DateTime.parse(row[:order_date])
    end_time = start_time + 1.0/24
  
    event = Google::Apis::CalendarV3::Event.new(
      summary: "Amazon購入履歴#{product_name}",
      location: '',
      description: body,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: start_time,
        time_zone: 'Asia/Tokyo'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: end_time,
        time_zone: 'Asia/Tokyo'
      )
    )

    result = @service.insert_event(calendar_id, event)
    puts "イベントを追加しました: #{result.html_link}"
  end

  private

  def service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @credentials
    return service
  end
end