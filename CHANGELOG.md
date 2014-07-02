1.0.0 (2014-07-01)
------------------

* Fixed compatibility with Mongoid 4.x and DelayedJob 4.x - [@dblock](http://github.com/dblock).

0.5.1 (2012-11-20)
------------------

* [#4](https://github.com/joeyAghion/delayed_job_shallow_mongoid/pull/4): Fix: `const_missing: uninitialized constant Delayed::DelayMail (NameError)` with Rails - [@dblock](http://github.com/dblock).
* [#4](https://github.com/joeyAghion/delayed_job_shallow_mongoid/pull/4): Fix: do not run job when a Mongoid instance is not found within delayed_job arguments and `Mongoid.raise_not_found_error` is set to `false` - [@dblock](http://github.com/dblock).

0.5.0 (2012-11-19)
------------------

* [#3](https://github.com/joeyAghion/delayed_job_shallow_mongoid/pull/3): Added Mongoid 3.x support - [@dblock](http://github.com/dblock).

0.4.0 (10/27/2012)
------------------

* [#2](https://github.com/joeyAghion/delayed_job_shallow_mongoid/pull/2): Silently return on documents that cannot be fetched - [@mixonic](https://github.com/mixonic).

0.3.0 (2/12/2012)
-----------------

* Delayed_job 3's requires are no longer relative to its root - [@joeyAghion](https://github.com/joeyAghion).
* Relaxed requirement for mongoid ~> 2.0 - [@dblock](http://github.com/dblock).

0.2.8 (1/4/2012)
----------------

* Don't transform object into stub if there are pending updates and jobs are being run immediately - [@joeyAghion](https://github.com/joeyAghion).
* Don't transform object into stub if not yet persisted - [@joeyAghion](https://github.com/joeyAghion).

0.2.7 (12/19/2011)
------------------

* Added support for embedded documents - [@joeyAghion](https://github.com/joeyAghion).

0.2.0 (11/29/2011)
------------------

* Reorganize and fix behavior for mailers - [@joeyAghion](https://github.com/joeyAghion).

0.1.0 (28/11/2011)
------------------

* Intial public release - [@joeyAghion](https://github.com/joeyAghion).
