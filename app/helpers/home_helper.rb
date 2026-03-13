module HomeHelper
  # 時間に応じたホーム画面での挨拶
  def greeting_message
    hour = Time.current.hour
    case hour
    when 5..11
      "おはようございます☀️"
    when 12..17
      "こんにちは😊"
    when 18..21
      "こんばんは🌙"
    else
      "お疲れ様です✨"
    end
  end

  def summary_message(checking_lists, today_lists, near_lists)
    total = checking_lists.size + today_lists.size + near_lists.size

    if total == 0
      "今日の予定はありません"
    elsif checking_lists.any?
      "チェック中のリストがあります"
    elsif today_lists.any?
      "今日のリストが #{today_lists.size}件 あります。"
    elsif near_lists.any?
      "近日中のリストが #{near_lists.size}件 あります。"
    else
      "直近のリストをチェック済みです"
    end
  end
end
