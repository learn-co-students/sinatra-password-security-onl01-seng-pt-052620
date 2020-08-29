class User < ActiveRecord::Base
    has_secure_password  
    #This is a macro that works in conjunction with bcrypt 
	
end