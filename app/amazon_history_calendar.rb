require "./lib/amazon.rb"
require "./lib/google.rb"

if __FILE__ == $0
    amazon = Amazon.new
    google_calendar = GoogleCalendar.new

    # csvファイルが存在するかチェックする
    file_name_list = ["amazon-order_non-digital.csv", "amazon-order_digital.csv"]
    executable_file_name_list= []
    file_name_list.each do |file_name|
        if amazon.exist_amazon_order_csv?(file_name) then
            executable_file_name_list.push(file_name)
        end
    end

    # Amazonの注文履歴を読み込む
    purchase_history_list = []
    if !executable_file_name_list.empty? then
        executable_file_name_list.each do |executable_file_name|
            purchase_history = amazon.read_amazon_order_csv(executable_file_name)
            purchase_history_list.push(purchase_history)
        end
    end

    # カレンダーにイベントを挿入する
    if !purchase_history_list.empty? then
        purchase_history_list.each do |purchase_history_table|
            purchase_history_table.each do |row|
                google_calendar.insert_event(row)
            end
        end
    end
end