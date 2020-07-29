class ApiVersionConstraint 

	def initialize(options) 
		@version = options[:version]
		@default = options[:default]
	end

	#verifica se foi passada alguma versão da api, senão ele passa a default
	def matches?(req)
		@default || req.headers['Accept'].include?("application/vnd.taskmanager.v#{@version}") 
	end

end