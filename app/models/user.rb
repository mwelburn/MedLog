class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :authentication_keys => [:login]

  has_many :events, :dependent => :destroy

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  #TODO - is this where facebook_id and twitter_id should be? they should only be created, never updated
  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates :username, :presence => true,
                       :length => { :maximum => 20 },
                       :uniqueness => true,
                       :format => { :with => /^\w+$/,
                                    :message => "can only contain letters, numbers, and underscores"
                                  }

  validates :name, :length => { :maximum => 50 }

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:facebook_id => data.id).first
      user
    else # Create a user with a stub password.
      #TODO - make sure to handle username not existing (does it exist in the data?)
      sanitized_username = data.username.gsub(/[^0-9a-z_]/i, '')
      user = User.new(:email => data.email, :name => data.name, :username => sanitized_username, :password => Devise.friendly_token[0,20])
      user.facebook_id = data.id
      begin
        user.save!
        #TODO - handle return of false..when would that happen
      rescue
        #TODO - redirect to 500 page
      end
      user
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token
    if user = User.where(:twitter_id => data.uid).first
      user
    else # Create a user with a stub password.
      logger.debug data
      #TODO - need to have a followup page that asks for an email?
      user = User.new(:name => data.info.name, :username => data.info.nickname, :password => Devise.friendly_token[0,20])
      user.twitter_id = data.id
      begin
        user.save!
        #TODO - handle return of false..when would that happen
      rescue
        #TODO - redirect to 500 page
      end
      user
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        #Currently do nothing. Maybe in the future we can keep information up to date (email,name,username/vanity)
        #assume whatever they start with, they might modify here to customize and we don't want to overwrite
      elsif data = session["devise.twitter_data"]
        #Currently do nothing. Maybe in the future we can keep information up to date (email,username)
        #assume whatever they start with, they might modify here to customize and we don't want to overwrite
      end
    end
  end

  #overwriting devise method
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def as_json(options={})
    super(:only => [:id, :username, :name, :email])
  end
end
