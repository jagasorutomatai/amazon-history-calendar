######################################
# Amazon-history-calendar
# [説明] 
# 
######################################

require 'yaml'
require "logger"
require "./lib/amazon/amazon.rb"

if __FILE__ == $0
    amazon = Amazon.new

    # Amazonの注文履歴のcsvファイル名を取得
    path = File.expand_path("../config/amazon.yaml", __FILE__)
    file_name_list = open(path, "r") { |f| YAML.load(f) }

    # csvファイルが存在するかチェックする
    executable_file_name_list= []
    file_name_list["file"].each do |key, value|
        if amazon.exist_amazon_order_csv?(value) then
            executable_file_name_list.push(value)
        end 
    end

    # Amazonの注文履歴を読み込む
    if !executable_file_name_list.empty? then
        purchase_history_list = []
        executable_file_name_list.each do |executable_file_name|
            purchase_history = amazon.read_amazon_order_csv(executable_file_name)
            purchase_history_list.push(purchase_history)
        end
        p purchase_history_list
    else
        # 処理なし
    end
end