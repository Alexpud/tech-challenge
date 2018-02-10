defmodule Account do

	defstruct(
		balance: 0,
		owner_name: 0,
		currency: ""
	)
	@typedoc """
This type does nothing but is there. It contains keys as folows:

* `:foo`: It holds something of type `Foo.t` but maybe `nil` of currently no `Foo.t` is available.
* `:title`: A human readable name for this instance. Maybe `nil` if it is not meant to be used to communicate to humans.
* ...
	"""
end