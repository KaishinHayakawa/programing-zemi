class User < ApplicationRecord
    has_many :tweets, dependent: :destroy
    has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :following_user, through: :follower, source: :followed
    has_many :follower_user, through: :followed, source: :follower
    has_many :retweets, dependent: :destroy
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true

    # ユーザーをフォローする
    def follow(user_id)
        follower.create(followed_id: user_id)
    end
    # ユーザーのフォローを外す
    def unfollow(user_id)
        follower.find_by(followed_id: user_id).destroy
    end
    # フォロー確認をおこなう
    def following?(user)
        following_user.include?(user)
    end

    # リツイート確認を行う
    def retweeted?(tweet_id)
        self.retweets.where(tweet_id: tweet_id).exists?
    end

    def tweets_with_retweets
        relation = Post.joins("LEFT OUTER JOIN retweets ON tweets.id = retweets.tweet_id AND retweets.user_id = #{self.id}")
                       .select("tweets.*, retweets.user_id AS retweet_user_id, (SELECT name FROM users WHERE id = retweet_user_id) AS retweet_user_name")
        relation.where(user_id: self.id)
                .or(relation.where("retweets.user_id = ?", self.id))
                .with_attached_images
                .preload(:user, :review, :comments, :likes, :retweets)
                .order(Arel.sql("CASE WHEN retweets.created_at IS NULL THEN tweets.created_at ELSE retweets.created_at END"))
    end
end
