Ruby Fork
==============

Use `ruby` to run applications as daemon.

Usage
----------------

Write the Forkfile and simply use `rork start` to start daemon and `rork stop` to stop!

Forkfile
-----------

	run <cmdline>

(Required) Determine the command line of the daemon.

	pid <pidfile>

(Required) Determine the file to store pid.

	log <logfile>

Determine the path of `STDOUT` of the daemon. The default value is `/dev/null`.

	err <errfile>

Determine the path of `STDERR` of the daemon. The default value is `/dev/null`

License
----------

The MIT License (MIT).

See `LICENSE` for details.

Author
----------

gyf1214
