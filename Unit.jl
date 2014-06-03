type SI
	value::Float64
	units::String

	function SI(x::String)
		string_match = match(r"[a-zA-Z]",x)
		unit_string_idx = string_match.offset 

		value = float(strip(x[1:unit_string_idx-1]))
		units = x[unit_string_idx:end]

		new(value, units)
	end
end