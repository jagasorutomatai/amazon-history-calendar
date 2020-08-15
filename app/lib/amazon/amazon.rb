require 'csv'
require 'pathname'

class Amazon
    HEADER_CONVERSION_MAP = {
        "注文日" => :order_date,
        "注文番号" => :order_number,
        "商品名" => :product_name,
        "付帯情報" => :supplementary_information,
        "価格" => :price,
        "個数" => :quantity,
        "商品小計" => :subtotal,
        "注文合計" => :order_total,
        "お届け先" => :destination,
        "状態" => :state,
        "請求先" => :billing_address,
        "請求額" => :billing_amount,
        "クレカ請求日" => :credit_card_billing_date,
        "クレカ請求額" => :credit_card_billing_amount,
        "クレカ種類" => :credit_card_types,
        "注文概要URL" => :order_summary_url,
        "領収書URL" => :receipt_url,
        "商品URL" => :product_url
    }

    # csvファイルの読み込み
    def read_amazon_order_csv(file_name)
        path = File.expand_path("../../../data", __FILE__)
        file = File.join(path, file_name)

        # ファイル内のダブルクオーテーションを削除
        buffer = File.open(file, "r") { |f| f.read() }
        buffer.gsub!(/"/, '')
        File.open(file, "w") { |f| f.write(buffer) }

        # csvファイルを読み込む
        header_converter = lambda { |h| HEADER_CONVERSION_MAP[h] }
        purchase_history_table = CSV.table(file, headers: true, header_converters: header_converter, skip_blanks: true)
        return purchase_history_table
    end

    # csvファイルの存在確認
    def exist_amazon_order_csv?(file_name)
        path = File.expand_path("../../../data", __FILE__)
        file = File.join(path, file_name)
        File.exist?(file)
    end
end