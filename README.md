SI.jl
=============

A Julia library for unit types validated unit conversions.


- **[Robert Moss](mailto:rmoss92@gmail.com)**

### Initialization

Load the library via ```require("SI.jl")``` then display the available types and explicit conversions with ```showSI()``` .


<sup>**Note:**</sup>  
<sup>Implicit types and conversions are available as long as each unit is defined within SI.jl</sup>  
<sup>**Example**:</sup>  
<sup>The type ```m/s``` is not defined, but both ```m``` (meters) and ```s``` (seconds) are defined.</sup>

### Unit Types
	
	distance = SI(90.2, :km) # kilometers
	time = SI(4.2, :s) # seconds

### Unit Arithmetic

	velocity = distance/time
	
	SI(21.476190476190474,:km/s,"kilometers per second",:velocity)


### Unit Conversion

	velocity >> symbol("m/s") # use symbol function for units containing '/'
	
	SI(21476.190079180236,:m/s,"meters per second",:velocity)

### User defined unit conversions

To add your own unit conversions to the ```unit_conversions.jl``` file.

##### Nomenclature for user defined unit conversions  
1. Use the macro ```@conversion``` to include the user defined function within ```showSI()```.  
2. Use the style of ```this_to_that(this)``` function names.