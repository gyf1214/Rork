module Parser
	module Inside
		module_function
		
		def pid path
			@app.pid = path
		end

		def log path
			@app.log = path
		end

		def err path
			@app.err = path
		end

		def run cmd
			@app.cmd = cmd
		end

		def app name = 'default'
			@app = Controller[name.to_s]
			yield
			@app = Controller['default']
		end
	end

	module_function

	def parse
		raise 'Forkfile not found' unless File.exist? 'Forkfile'
		forkfile = File.read 'Forkfile'
		Inside.app do
			Inside.instance_eval forkfile
		end
	end
end