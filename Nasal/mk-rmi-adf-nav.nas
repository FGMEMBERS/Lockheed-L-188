# Nasal code to push FALSE values into the adf[0] and adf[1] in-range properties
# on a 4 second interval - this is a bash to make ADF work correctly since there
# is an issue where the in-range does not go back to FALSE on its own.  If you
# truly ARE in range it will flip back to TRUE instantly on its own, but will stay
# at FALSE if you are indeed out of range
#
# Wolfram Gottfried aka 'Yakko'

var adf_false_tick = func {
  setprop("/instrumentation/adf[0]/in-range", 0);
  setprop("/instrumentation/adf[1]/in-range", 0);
  settimer(adf_false_tick, 4);
}
adf_false_tick();

# Stolen from the Lockheed 1049H Constellation by M.Kraus :-))
#
# Instrumentation and Related Drivers
#
# Code by Gary Neely aka 'Buckaroo' except as otherwise noted

# Support to calculate RMI needle deflections based on mode (VOR/ADF)
# and beacon range. Simplifies RMI animations.
#
# Reads two custom properties:
#   /instrumentation/rmi-needle[0]/mode		(values 'vor'|'adf', default 'vor'), actually: 0|1 default 0
#   /instrumentation/rmi-needle[1]/mode		(values 'vor'|'adf', default 'vor'), actually: 0|1 default 0
#
# These should be set by cockpit switches to control the two RMI needles.
#
# Function writes to two custom properties:
#  /instrumentation/rmi-needle[0]/value
#  /instrumentation/rmi-needle[1]/value
#
# These are read by the RMI instrument animations.
#
# This code is based in part on code originally suggested by Wolfram Gottfried aka 'Yakko'.
#

var UPDATE_PERIOD	= 2;				# How often to update main loop in seconds (0 = framerate)

var rmi1	= props.globals.getNode("/instrumentation/rmi-needle[0]");
var rmi2	= props.globals.getNode("/instrumentation/rmi-needle[1]");
var adf1	= props.globals.getNode("/instrumentation/adf[0]");
var adf2	= props.globals.getNode("/instrumentation/adf[1]");

var update_rmi = func {

  var needle1 = 90;						# Needle default off or out-of-range positions
  var needle2 = 270;

  if(adf1.getNode("in-range").getValue()) {
    needle1 = adf1.getNode("indicated-bearing-deg").getValue();
  }

  if(adf2.getNode("in-range").getValue()) {
    needle2 = adf2.getNode("indicated-bearing-deg").getValue();
  }

  interpolate("/instrumentation/rmi-needle[0]/value", needle1, 1.75);
  interpolate("/instrumentation/rmi-needle[1]/value", needle2, 1.5);

  settimer(update_rmi, UPDATE_PERIOD);
}
update_rmi();

#
# Round-off errors screw-up the textranslate animation used to display digits. This is a problem
# for the NAV and COMM freq display. This seems to affect only decimal place digits. So here I'm using
# a listener to copy the MHz and KHz portions of a freq string to a separate integer values
# that are used by the animations.
#

var nav1selstr	= props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz-fmt");
var nav1selmhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sel-mhz");
var nav1selkhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sel-khz");
var nav2selstr	= props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz-fmt");
var nav2selmhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sel-mhz");
var nav2selkhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sel-khz");
var nav1sbystr	= props.globals.getNode("/instrumentation/nav[0]/frequencies/standby-mhz-fmt");
var nav1sbymhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sby-mhz");
var nav1sbykhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sby-khz");
var nav2sbystr	= props.globals.getNode("/instrumentation/nav[1]/frequencies/standby-mhz-fmt");
var nav2sbymhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sby-mhz");
var nav2sbykhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sby-khz");

							# This initializes the values
var navtemp = split(".",nav1selstr.getValue());
nav1selmhz.setValue(navtemp[0]);
nav1selkhz.setValue(navtemp[1]);
navtemp = split(".",nav2selstr.getValue());
nav2selmhz.setValue(navtemp[0]);
nav2selkhz.setValue(navtemp[1]);
navtemp = split(".",nav1sbystr.getValue());
nav1sbymhz.setValue(navtemp[0]);
nav1sbykhz.setValue(navtemp[1]);
navtemp = split(".",nav2sbystr.getValue());
nav2sbymhz.setValue(navtemp[0]);
nav2sbykhz.setValue(navtemp[1]);
							# And these make sure they're updated
setlistener(nav1selstr, func {
  var navtemp = split(".",nav1selstr.getValue());
  nav1selmhz.setValue(navtemp[0]);
  nav1selkhz.setValue(navtemp[1]);
});
setlistener(nav2selstr, func {
  var navtemp = split(".",nav2selstr.getValue());
  nav2selmhz.setValue(navtemp[0]);
  nav2selkhz.setValue(navtemp[1]);
});
setlistener(nav1sbystr, func {
  var navtemp = split(".",nav1sbystr.getValue());
  nav1sbymhz.setValue(navtemp[0]);
  nav1sbykhz.setValue(navtemp[1]);
});
setlistener(nav2sbystr, func {
  var navtemp = split(".",nav2sbystr.getValue());
  nav2sbymhz.setValue(navtemp[0]);
  nav2sbykhz.setValue(navtemp[1]);
});


var comm1sel	= props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz");
var comm1sby	= props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz");
var comm1selstr	= props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz-fmt");
var comm1sbystr	= props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz-fmt");
var comm1selmhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sel-mhz");
var comm1selkhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sel-khz");
var comm1sbymhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sby-mhz");
var comm1sbykhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sby-khz");

var comm2sel	= props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz");
var comm2sby	= props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz");
var comm2selstr	= props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz-fmt");
var comm2sbystr	= props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz-fmt");
var comm2selmhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sel-mhz");
var comm2selkhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sel-khz");
var comm2sbymhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sby-mhz");
var comm2sbykhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sby-khz");

							# Update support vars on comm change
setlistener(comm1sel, func {
  var commstr = sprintf("%.2f",comm1sel.getValue());	# String conversion
  var commtemp = split(".",commstr);			# Split into MHz and KHz
  comm1selmhz.setValue(commtemp[0]);
  comm1selkhz.setValue(commtemp[1]);
});
setlistener(comm1sby, func {
  var commstr = sprintf("%.2f",comm1sby.getValue());
  var commtemp = split(".",commstr);
  comm1sbymhz.setValue(commtemp[0]);
  comm1sbykhz.setValue(commtemp[1]);
});
setlistener(comm2sel, func {
  var commstr = sprintf("%.2f",comm2sel.getValue());
  var commtemp = split(".",commstr);
  comm2selmhz.setValue(commtemp[0]);
  comm2selkhz.setValue(commtemp[1]);
});
setlistener(comm2sby, func {
  var commstr = sprintf("%.2f",comm2sby.getValue());
  var commtemp = split(".",commstr);
  comm2sbymhz.setValue(commtemp[0]);
  comm2sbykhz.setValue(commtemp[1]);
});

							# Set comm support vars to startups
var update_comms = func {
  var commstr = "";
  var commtemp = 0;

  commstr = sprintf("%.2f",comm1sel.getValue());
  commtemp = split(".",commstr);
  comm1selmhz.setValue(commtemp[0]);
  comm1selkhz.setValue(commtemp[1]);
  commstr = sprintf("%.2f",comm1sby.getValue());
  commtemp = split(".",commstr);
  comm1sbymhz.setValue(commtemp[0]);
  comm1sbykhz.setValue(commtemp[1]);

  commstr = sprintf("%.2f",comm2sel.getValue());
  commtemp = split(".",commstr);
  comm2selmhz.setValue(commtemp[0]);
  comm2selkhz.setValue(commtemp[1]);
  commstr = sprintf("%.2f",comm2sby.getValue());
  commtemp = split(".",commstr);
  comm2sbymhz.setValue(commtemp[0]);
  comm2sbykhz.setValue(commtemp[1]);

  settimer(update_comms, 2);
}

update_comms();

