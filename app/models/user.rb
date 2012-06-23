class User < ActiveRecord::Base

  attr_accessible :name,
                  :uid


  has_many :statuses, :dependent => :destroy

  def self.find_or_create_from_auth_hash(auth_hash)
    User.find_or_create_by_uid(auth_hash[:uid].to_s, :name => auth_hash[:info][:name])
  end
end
