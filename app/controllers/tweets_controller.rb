class TweetsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
    before_action :correct_user, only: [:destroy, :edit, :update]

    def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
        flash[:success] = "投稿されました！"
        redirect_to root_url
    else
        render 'static_pages/home'
    end
end

def edit
    @tweet = Tweet.find (params[:id])
end

def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update(tweet_params)
        flash[:success] = "変更を保存しました。"
        redirect_to root_url
    else
        render 'edit'
    end
end

def destroy
    @tweet.destroy
    flash[:success] = "削除しました"
    redirect_to request.referrer || root_url
end 

private
    
    def tweet_params
        params.require(:tweet).permit(:content)
    end
    
    def correct_user
        @tweet = current_user.tweets.find_by(id: params[:id])
        if @tweet.nil?
            flash[:danger] = "不正なアクセスです"
            redirect_to root_url    
        end
    end
end
