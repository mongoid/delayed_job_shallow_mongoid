delayed_job_shallow_mongoid
===========================

[![Build Status](https://secure.travis-ci.org/joeyAghion/delayed_job_shallow_mongoid.png?branch=master)](http://travis-ci.org/joeyAghion/delayed_job_shallow_mongoid)

This library short-circuits serialization of [Mongoid](http://mongoid.org) model instances when a delayed job is called on them, or when they're passed as arguments to a delayed job. Rather than generate and store the fully-serialized YAML, a simple stub is stored. When the job is run, the stub is recognized and a `find` is done to look up the underlying document. If a referenced model isn't found at this point, the job simply does nothing.

Going forward, only [Mongoid 3](http://mongoid.org) will be supported. Feel free to fork and submit pull-requests for backward-compatibility.

Contributions
-------------

* Contributions encouraged. Feature branches appreciated.
* Development generously supported by [Art.sy](http://art.sy).

Copyright
---------

Copyright (c) 2011 Joey Aghion, Art.sy Inc. See LICENSE.txt for further details.
