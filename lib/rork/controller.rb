module Controller
	class Application
		attr_accessor :pid, :log, :err, :cmd

		def initialize
			@err = @log = '/dev/null'
		end
	end

	module_function

	@apps = Hash.new
	def [] key
		@apps[key] = Application.new unless @apps.key? key
		@apps[key]
	end

	def start args = []
		begin
			args[0] = 'default' if args[0].nil?
			@app = @apps[args[0]]
			raise "Daemon #{args[0]} not found!" if @app.nil?

			puts "Starting daemon #{args[0]}..."
			raise "Pid file must be given for #{args[0]}!" if @app.pid.nil?
			raise "Command must be given for #{args[0]}!" if @app.cmd.nil?
			raise "Daemon #{args[0]} already running!" if File.exist? @app.pid

			id = Process.fork do
				Process.setsid
				STDIN.reopen '/dev/null', 'r'
				STDOUT.reopen @app.log, 'a'
				STDERR.reopen @app.err, 'a'
				STDOUT.sync = true
				STDERR.sync = true
				exec @app.cmd
			end

			raise 'Fork failed!' if id.nil?

			File.open @app.pid, 'w' do |file|
				file << id
			end
		rescue Exception => e
			puts '[Failed]'
			puts e.to_s
			exit
		end

		puts '[Success]'
	end

	def stop args = []
		begin
			args[0] = 'default' if args[0].nil?
			@app = @apps[args[0]]
			raise "Daemon #{args[0]} not found!" if @app.nil?

			puts "Stopping daemon #{args[0]}..."
			raise "Pid file must be given for #{args[0]}!" if @app.pid.nil?
			raise "Daemon #{args[0]}not running!" unless File.exist? @app.pid

			id = File.read @app.pid
			id = id.to_i

			Process.kill 'TERM', id

			File.delete @app.pid
		rescue Exception => e
			puts '[Failed]'
			puts e.to_s
			exit
		end

		puts '[Success]'
	end

	def run cmd, args = []
		cmds = {
			'start' => :start,
			'stop' => :stop
		}

		raise "Unknown command #{cmd}" if cmds[cmd].nil?

		send cmds[cmd], args
	end
end
