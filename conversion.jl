macro conversion(func::Expr)
	global conversion_functions
	eval(func)
	if !isdefined(:conversion_functions)
		conversion_functions = []
	end

	if !in(func.args[1], conversion_functions)
		conversion_functions = [conversion_functions, func.args[1]]
	end
end