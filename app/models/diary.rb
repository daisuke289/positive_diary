class Diary < ApplicationRecord
  validates :content, presence: true, length: { maximum: 2000 }
  validates :mood_score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
  
  before_save :generate_summary, if: -> { content_changed? && summary.blank? }
  
  def tag_list
    tags.to_s.split(',').map(&:strip)
  end
  
  def tag_list=(tags_string)
    self.tags = tags_string.split(',').map(&:strip).join(',')
  end
  
  private
  
  def generate_summary
    return if content.blank?
    
    openai_service = OpenaiService.new
    self.summary = openai_service.generate_summary(content)
  rescue => e
    Rails.logger.error("自動要約の生成に失敗しました: #{e.message}")
    # 失敗しても処理を続行する（summaryはnilのまま）
  end
end
