# Lockheed L-188 Electra
# Nasal door system
#########################

var Door =
{
	new: func(name, transit_time)
	{
		return aircraft.door.new("sim/model/door-positions/" ~ name, transit_time);
	}
};
var doors =
{
	leftfrontdoor: Door.new("leftfrontdoor", 3),
	leftbackdoor: Door.new("leftbackdoor", 3),
  cockpitdoor: Door.new("cockpitdoor", 3)
};
