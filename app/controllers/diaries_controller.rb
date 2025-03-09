class DiariesController < ApplicationController
  def new
    @diary = Diary.new
  end

  def create
    @diary = Diary.new(diary_params)
    
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

  private

  def diary_params
    params.require(:diary).permit(:content)
  end
end
