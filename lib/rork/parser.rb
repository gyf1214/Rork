module Parser
	module Inside
		module_function
		
		def pid path
			Controller.pid = path
		end

		def log path
			Controller.log = path
		end

		def err path
			Controller.err = path
		end

		def run cmd
			Controller.cmd = cmd
		end
	end

	module_function

	def parse
		raise 'Forkfile not found' unless File.exist? 'Forkfile'
		forkfile = File.read 'Forkfile'
		Inside.instance_eval forkfile
	end
end