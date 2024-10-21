class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    if Plan.create(plan_params)
      redirect_to action: :index
    else
      flash[:error] = '予定の保存に失敗しました。'
      redirect_to action: :index
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)

  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      puts "Date: #{(@todays_date + x)}"

      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans}
      
      # 現在の日の曜日を取得
      wday_num = (@todays_date + x).wday
      
       # 月、日、曜日、予定を含むハッシュを作成
       days = { 
        month: (@todays_date + x).month, 
        date: (@todays_date + x).day, 
        wday: wdays[wday_num], 
        plans: today_plans 
      }

      # 配列に日を追加
      @week_days.push(days)
    end
  end

end