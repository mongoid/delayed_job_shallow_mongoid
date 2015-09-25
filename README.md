delayed_job_shallow_mongoid
===========================

[![Build Status](https://secure.travis-ci.org/joeyAghion/delayed_job_shallow_mongoid.svg?branch=master)](http://travis-ci.org/joeyAghion/delayed_job_shallow_mongoid)
[![Gem Version](https://badge.fury.io/rb/delayed_job_shallow_mongoid.svg)](http://badge.fury.io/rb/delayed_job_shallow_mongoid)

This library short-circuits serialization of [Mongoid](http://mongoid.org) model instances when a delayed job is called on them, or when they're passed as arguments to a delayed job. Rather than generate and store the fully-serialized YAML, a simple stub is stored. When the job is run, the stub is recognized and a `find` is done to look up the underlying document. If a referenced model isn't found at this point, the job simply does nothing.

This gem supports Mongoid 3.x, 4.x and 5.x.

Contributions
-------------

* Contributions encouraged. Feature branches appreciated.
* Development generously supported by [Artsy](http://artsy.net).

Copyright
---------

Copyright (c) 2011-2015 Joey Aghion, Artsy Inc.

MIT License. See [LICENSE](LICENSE.txt) for further details.
