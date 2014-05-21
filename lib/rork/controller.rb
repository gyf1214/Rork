module Controller
	private

	def self.module_attr *names
		names.each do |name|
			instance_eval %{
				def #{name}
					@#{name}
				end

				def #{name}= arg
					@#{name} = arg
				end
			}
		end
	end

	public

	module_function

	@err = @log = '/dev/null'

	module_attr :pid, :log, :err, :cmd

	def start
		begin
			puts 'Starting daemon'

			raise 'Daemon already running!' if File.exist? @pid

			id = Process.fork do
				Process.setsid
				STDIN.reopen '/dev/null', 'r'
				STDOUT.reopen @log, 'a'
				STDERR.reopen @err, 'a'
				STDOUT.sync = true
				STDERR.sync = true
				exec @cmd
			end

			raise 'Fork failed!' if id.nil?

			File.open @pid, 'w' do |file|
				file << id
			end
		rescue Exception => e
			puts '[Failed]'
			puts e.to_s
			exit
		end

		puts '[Success]'
	end

	def stop
		begin
			puts 'Stopping daemon'

			raise 'Daemon not running!' unless File.exist? @pid

			id = File.read @pid

			Process.kill 'TERM', id.to_i

			File.delete @pid
		rescue Exception => e
			puts '[Failed]'
			puts e.to_s
			exit
		end

		puts '[Success]'
	end

	def run cmd
		cmds = {
			'start' => :start,
			'stop' => :stop
		}

		raise "Unknown command #{cmd}" if cmds[cmd].nil?

		send cmds[cmd]
	end
end
