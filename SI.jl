reload("conversion.jl")
reload("unit_conversions.jl")

type SI
	value::Float64
	unit::Symbol
	unit_string::String
	unit_type::Symbol

	function SI(x::String)
		string_match = match(r"[a-zA-Z]",x)
		unit_string_idx = string_match.offset 

		value = float(strip(x[1:unit_string_idx-1]))
		unit = symbol(x[unit_string_idx:end])
		unit_string, unit_type = declare_type(unit)


		new(value, unit, unit_string, unit_type)
	end

	SI(value::Float64, unit::Symbol, unit_string::ASCIIString, unit_type::Symbol) = new(value, unit, unit_string, unit_type)

	SI(value::Number, unit::Symbol) = new(value, unit, declare_type(unit)[1], declare_type(unit)[2])
	SI(value::Integer, unit::Symbol) = SI(float(value), unit)

end

#
# Operator overloading
#

function *(m1::SI, m2::SI)
	if m1.unit_type != m2.unit_type
		error("The unit types do not match; ", m1.unit_type, " and ", m2.unit_type,".")
	end
	standard_unit = SI(m1.value * m2.value, symbol(string(m1.unit, "*", m2.unit)), string(m1.unit_string, " ", m2.unit_string))

	return standard_unit
end

function /(m1::SI, m2::SI)
	new_unit = symbol(string(m1.unit, "/", m2.unit))
	new_unit_string, new_unit_type = declare_type(new_unit)

	standard_unit = SI(m1.value / m2.value, new_unit, new_unit_string, new_unit_type)

	return standard_unit
end

#
# Uses:	
#
#	siUnit >> :m 	# Converts the siUnit to meters (returns the changed siUnit)
#	siUnit >>= :m 	# Converts the siUnit to meters (modifies the current siUnit)

>>(from::SI, to_sym::Symbol) = return to(from, to_sym)

function showSI(pretty_print=true)
	if pretty_print
		unit_names = get_unit_names()
		for unit in unit_names
			println("\n------------------------------------------------------\n")
			println(unit[1], " units")
			for u in unit[2]
				println("\t", u)
			end
			println("\n", unit[1], " conversion functions:")
			cfunc = []
			for u in unit[2]
				for c in conversion_functions
					if contains(string(c.args[1]), string(u[1],"_"))
						cfunc = [cfunc, c]
					end
				end
			end 

			if length(cfunc) == 0
				println("\tNo conversion functions defined.")
				continue
			end

			for c in cfunc
				println("\t",c)
			end
		end
	else
		println(get_unit_names())
	end
end

function get_unit_names()
	length = [:kpc=>"kiloparsec", :km=>"kilometer", :m=>"meter", :cm=>"centimeter"]
	time = [:s=>"second", :min=>"minute", :hr=>"hour"]
	mass = [:kg=>"kilogram"]
	velocity = [symbol("m/s")=>"meters per second", symbol("km/s")=>"kilometers per second", symbol("km/hr")=>"kilometers per hour", symbol("m/hr")=>"meters per hour"]
	acceleration = [symbol("m/s^2")=>"meters per second squared", symbol("km/s^2")=>"kilometers per second squared"]
	electric_current = [:A=>"ampere"]
	temperature = [:K=>"kelvin"]
	amount_of_substance = [:mol=>"mole"]
	luminousity = [:cd=>"candela"] 
	density = [:GeVcm3=>"Giga electron volts per centimeter cubed", :kgkms2=>"kilograms per kilometer seconds squared"]

	units = [	:length=>length,
				:time=>time,
				:mass=>mass,
				:velocity=>velocity,
				:acceleration=>acceleration,
				:electric_current=>electric_current,
				:amount_of_substance=>amount_of_substance,
				:luminousity=>luminousity,
				:density=>density	]

	return units
end

function declare_type(unit::Symbol)
	unit_names = get_unit_names()

	unit_string = nothing
	unit_type = nothing

	for u in unit_names
		unit_string = get(u[2], unit, nothing)
		if unit_string != nothing
			unit_type = u[1]
			return unit_string, unit_type
		end
	end

	error("Undeclared unit type. Add unit to the units dictionary.")
	return unit_string, unit_type
end

function to(input::SI, new_unit::Symbol)
	old_unit = input.unit
	old_unit_string, old_unit_type = declare_type(old_unit)
	new_unit_string, new_unit_type = declare_type(new_unit)

	# Error checking
	if old_unit == new_unit
		return input
	elseif old_unit_type != new_unit_type
		error("Unit types (from ", old_unit_type, " to ", new_unit_type, ") must match to convert.")
	elseif old_unit_string == nothing
		error("No conversion available from ", old_unit, " to ", new_unit, ".")
	end

	func::Symbol

	if contains(string(old_unit), "/")
		old_unit_split = split(string(old_unit), "/")
		new_unit_split = split(string(new_unit), "/")
		func_old_unit, func_new_unit = nothing, nothing

		if old_unit_split[1] == new_unit_split[1]
			func_old_unit, func_new_unit = old_unit_split[2], new_unit_split[2]
		else
			func_old_unit, func_new_unit = old_unit_split[1], new_unit_split[1]
		end

		func = symbol(string(func_old_unit,"_to_",func_new_unit))

	else
		func = symbol(string(old_unit,"_to_",new_unit)) 
	end


	try
		new_value = eval(Expr(:call, func, input.value))
		return SI(new_value, new_unit, new_unit_string, new_unit_type)
	catch UndefRefError
		error("Undefined function ", func)
	end
end