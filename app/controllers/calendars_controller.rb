class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create

    Plan.create(plan_params)
    redirect_to action: :index
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
    # 一日の予定を格納するための配列を準備
    today_plans = []
    plans.each do |plan|
      # 予定の日付が一致したら、その予定をtoday_plansに追加
      today_plans.push(plan.plan) if plan.date == @todays_date + x
    end

    # x日後の日付から曜日を取得
    wday = (@todays_date + x).wday

    # 日付、曜日、予定をハッシュに格納
    day = {
      month: (@todays_date + x).month,
      date: (@todays_date + x).day,
      plans: today_plans,
      wday: wdays[wday]
    }

    # ハッシュを@week_days配列に追加
    @week_days.push(day)
    end
  end
end
