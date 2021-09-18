class RetweetsController < ApplicationController
    before_action :set_tweet
      
    def create  # リツイートボタンを押すと、押したユーザーと押した投稿のIDよりretweetsテーブルに登録する
      logger.info "リツイートユーザーID　#{current_user.id}"
      @retweet = Retweet.find_by(user_id: current_user.id, tweet_id: @tweet.id)
      logger.info "リツイートユーザー　#{@retweet}"
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
end
