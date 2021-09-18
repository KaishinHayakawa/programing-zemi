class StaticPagesController < ApplicationController
  def home
    @tweet = current_user.tweets.build if logged_in?
    @tweets = Tweet.all.order(created_at: "DESC").paginate(page: params[:page],per_page: 10) if logged_in?
    @retweet = current_user.retweets.build unless logged_in?
    @retweets = Retweet.all.order(created_at: "DESC") unless logged_in?
  end

  def create  # リツイートボタンを押すと、押したユーザーと押した投稿のIDよりretweetsテーブルに登録する
    if Retweet.find_by(user_id: current_user.id, tweet_id: @tweet.id)
      redirect_to root_path, alert: '既にリツイート済みです'
    else
      @retweet = Retweet.create(user_id: current_user.id, tweet_id: @tweet.id)
    end
  end
  
  def destroy  # 既にリツイートした投稿のリツイートボタンを再度押すと、リツイートを取り消す（=テーブルからデータを削除する）
    @retweet = current_user.retweets.find_by(tweet_id: @tweet.id)
    if @retweet.present?
      @retweet.destroy
    else
      redirect_to root_path, alert: '既にリツイートを取り消し済みです'
    end
  end
    
  private
  def set_tweet  # リツイートボタンを押した投稿を特定する
    @tweet = Tweet.find(params[:tweet_id])
    if @tweet.nil?
      redirect_to root_path, alert: '該当の投稿が見つかりません'
    end
  end
  
  def help
  end

  def about
  end

  def contact
  end
end
