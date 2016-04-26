module SpecTestHelper

	# Sessions 
	def login(user)
	  post :create, session: { email: user.email, password: user.password }
	end
	def logout(user)
	  delete :destroy, session: { email: user.email, password: user.password }
	end

end