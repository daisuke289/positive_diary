class OpenaiService
  def initialize
    api_key = ENV['OPENAI_API_KEY']
    if api_key.nil? || api_key.empty?
      Rails.logger.error("OpenAI API key is not set")
    else
      Rails.logger.debug("OpenAI API key is set: #{api_key[0..5]}...#{api_key[-5..-1]}")
    end

    @client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'], # 'access_token'パラメータに変更
      uri_base: "https://api.openai.com",  # URIベースを明示的に指定
      request_timeout: 60                  # タイムアウト時間を増やす
    )
  end

  def convert_to_positive(text)
    begin
      Rails.logger.debug("Attempting to convert text with OpenAI API...")
      
      # シンプルなリクエストパラメータに変更
      response = @client.chat(
        parameters: {
          model: "gpt-3.5-turbo", # より安価なモデルに変更（動作確認用）
          messages: [
            { role: "system", content: "あなたは文章を前向きでポジティブな表現に変換する専門家です。入力された文章を分析し、ネガティブな表現や弱気な表現を見つけて、それをポジティブで励まし、応援する表現に変換してください。変換は単に言葉を変えるだけでなく、前向きな気持ちになれるような温かみのある表現にしてください。" },
            { role: "user", content: text }
          ],
          temperature: 0.7,
          max_tokens: 500
        }
      )

      # レスポンスの構造をデバッグ出力
      Rails.logger.debug("OpenAI API Response: #{response.inspect}")
      
      if response["error"]
        Rails.logger.error("OpenAI API Error: #{response["error"]["message"]}")
        return "申し訳ありません。テキスト変換中にエラーが発生しました: #{response["error"]["message"]}"
      end

      content = response.dig("choices", 0, "message", "content")
      Rails.logger.debug("Generated content: #{content}")
      return content || "テキスト変換に失敗しました。"
    rescue => e
      Rails.logger.error("OpenAI API Error: #{e.message}")
      return "申し訳ありません。テキスト変換中にエラーが発生しました。しばらく経ってからもう一度お試しください。(#{e.message})"
    end
  end
end 