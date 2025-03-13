class User < ApplicationRecord
    # 비밀번호 암호화를 위한 메서드 추가
    has_secure_password
  
    # 연관 관계 설정
    has_many :posts
  
    # 유효성 검사 추가
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, 
              format: { with: URI::MailTo::EMAIL_REGEXP }
    
    # 이메일을 소문자로 저장
    before_save :downcase_email
  
    private
  
    def downcase_email
      self.email = email.downcase if email.present?
    end
  end