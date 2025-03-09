class DiariesController < ApplicationController
  def index
    @diaries = Diary.order(created_at: :desc)
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = Diary.new(diary_params)
    
    # OpenAI APIで自動タグ生成
    if params[:auto_tag] == "1" && @diary.tags.blank?
      openai_service = OpenaiService.new
      tags = openai_service.suggest_tags(@diary.content)
      @diary.tags = tags if tags.present?
    end
    
    if @diary.save
      # OpenAI APIを使用してポジティブな内容に変換
      openai_service = OpenaiService.new
      positive_content = openai_service.convert_to_positive(@diary.content)
      
      # 変換結果を保存
      @diary.update(positive_content: positive_content)
      
      redirect_to @diary, notice: 'あなたの日記が前向きなメッセージに変換されました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @diary = Diary.find(params[:id])
  end
  
  def search
    if params[:tag].present?
      @diaries = Diary.where("tags LIKE ?", "%#{params[:tag]}%").order(created_at: :desc)
    else
      @diaries = Diary.order(created_at: :desc)
    end
    render :index
  end
  
  def stats
    @total_entries = Diary.count
    @average_mood = Diary.where.not(mood_score: nil).average(:mood_score).to_f.round(1)
    @mood_data = Diary.where.not(mood_score: nil).group_by_day(:created_at).average(:mood_score)
    @tags_data = Diary.where.not(tags: nil).where.not(tags: '').pluck(:tags).join(',').split(',').tally.sort_by { |k, v| -v }.first(10).to_h
  end

  private

  def diary_params
    params.require(:diary).permit(:content, :mood_score, :tags, :tag_list)
  end
end
