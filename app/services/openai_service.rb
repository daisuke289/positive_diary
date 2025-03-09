class OpenaiService
  def initialize
    api_key = ENV['OPENAI_API_KEY']
    if api_key.nil? || api_key.empty?
      Rails.logger.error("OpenAI API key is not set")
    else
      Rails.logger.debug("OpenAI API key is set: #{api_key[0..5]}...#{api_key[-5..-1]}")
    end

    @client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
      uri_base: "https://api.openai.com",
      request_timeout: 60
    )
  end

  def convert_to_positive(text)
    begin
      Rails.logger.debug("Attempting to convert text with OpenAI API...")
      
      response = @client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "あなたは文章を前向きでポジティブな表現に変換する専門家です。入力された文章を分析し、ネガティブな表現や弱気な表現を見つけて、それをポジティブで励まし、応援する表現に変換してください。変換は単に言葉を変えるだけでなく、前向きな気持ちになれるような温かみのある表現にしてください。" },
            { role: "user", content: text }
          ],
          temperature: 0.7,
          max_tokens: 500
        }
      )

      Rails.logger.debug("OpenAI API Response class: #{response.class.name}")
      Rails.logger.debug("OpenAI API Response: #{response.inspect}")
      
      content = case response
                when Hash
                  if response["error"]
                    Rails.logger.error("OpenAI API Error: #{response["error"]["message"]}")
                    return "申し訳ありません。テキスト変換中にエラーが発生しました: #{response["error"]["message"]}"
                  end
                  response.dig("choices", 0, "message", "content")
                else
                  begin 
                    if response.respond_to?(:choices) && response.choices.any?
                      if response.choices[0].respond_to?(:message)
                        response.choices[0].message.content
                      else
                        response.choices[0][:message][:content] rescue nil
                      end
                    end
                  rescue => e
                    Rails.logger.error("Error parsing response: #{e.message}")
                    nil
                  end
                end
                 
      Rails.logger.debug("Generated content: #{content}")
      return content || "テキスト変換に失敗しました。"
    rescue => e
      Rails.logger.error("OpenAI API Error: #{e.message}")
      return "申し訳ありません。テキスト変換中にエラーが発生しました。しばらく経ってからもう一度お試しください。(#{e.message})"
    end
  end
end 