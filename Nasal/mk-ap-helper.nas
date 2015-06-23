#=======================================================================
# In copilot mode the value of autopilot kill all pilot - copilot action
# ok, so pilot settings must be written to switch boolean values
#=======================================================================
setlistener("/sim/signals/fdm-initialized", func {
      setprop("/autopilot/locks/altitude", "");
      setprop("/autopilot/locks/heading", "");
      setprop("/autopilot/locks/speed", "");
      setprop("/autopilot/switches/ap", 0);
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/ias", 0);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/gps", 0);
      setprop("/autopilot/switches/pitch", 0);
});

setlistener("/autopilot/switches/ap", func (ap){
    var ap = ap.getBoolValue();
    if (ap == 1){
      var hdgSet = getprop("/autopilot/switches/hdg");
      var altSet = getprop("/autopilot/switches/alt");
      var iasSet = getprop("/autopilot/switches/ias");
      var navSet = getprop("/autopilot/switches/nav");
      var apprSet = getprop("/autopilot/switches/appr");
      var gpsSet = getprop("/autopilot/switches/gps");
      var pitchSet = getprop("/autopilot/switches/pitch");

      if((!hdgSet and !altSet and !iasSet and !navSet and !apprSet and !gpsSet and !pitchSet)){
        setprop("/autopilot/locks/heading", "wing-leveler");
        setprop("/autopilot/locks/altitude", "pitch-hold");
        setprop("/autopilot/settings/target-pitch-deg", 
                      getprop("/orientation/pitch-deg"));
      }

    }else{
      setprop("/autopilot/locks/altitude", "");
      setprop("/autopilot/locks/heading", "");
      setprop("/autopilot/locks/speed", "");
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/ias", 0);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/gps", 0);
      setprop("/autopilot/switches/pitch", 0);
      applyTrimWheels(0, 0);
      applyTrimWheels(0, 1);
      applyTrimWheels(0, 2);
    }
});

setlistener("/autopilot/switches/hdg", func (hdg){
    var hdg = hdg.getBoolValue();
    if (hdg == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/switches/gps", 0);
      setprop("/autopilot/locks/heading", "dg-heading-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/alt", func (alt){
    var alt = alt.getBoolValue();
    if (alt == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/pitch", 0);
      setprop("/autopilot/locks/altitude", "altitude-hold");
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});

setlistener("/autopilot/switches/ias", func (ias){
    var ias = ias.getBoolValue();
    if (ias == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/locks/speed", "speed-with-throttle");
    }else{
      setprop("/autopilot/locks/speed", "");
    }
});

#setlistener("/autopilot/switches/pitch", func (pitch){
#    var pitch = pitch.getBoolValue();
#    if (pitch == 1){
#      setprop("/autopilot/switches/ap", 1);
#      setprop("/autopilot/switches/appr", 0);
#      setprop("/autopilot/switches/alt", 0);
#      setprop("/autopilot/locks/altitude", "pitch-hold");
#      setprop("/autopilot/settings/target-pitch-deg", 
#                    getprop("/orientation/pitch-deg"));
#    }else{
#      setprop("/autopilot/locks/altitude", "");
#    }
#});

# before it was pitch, so I use this switch knob called pitch, but now it maps on vertical speed 
setlistener("/autopilot/switches/pitch", func (pitch){
    var pitch = pitch.getBoolValue();
    if (pitch == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/locks/altitude", "vertical-speed-hold");
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});

setlistener("/autopilot/switches/gps", func (gps){
    var gps = gps.getBoolValue();
    var routeIsSet = getprop("/autopilot/settings/gps-driving-true-heading") or 0;
    if (gps == 1){
      if (routeIsSet == 1){
        setprop("/autopilot/switches/ap", 1);
        setprop("/autopilot/switches/hdg", 0);
        setprop("/autopilot/switches/nav", 0);
        setprop("/autopilot/locks/heading", "true-heading-hold");
      }else{
        settimer(switchback, 0.250 );
      }
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/nav", func (nav){
    var nav = nav.getBoolValue();
    if (nav == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/gps", 0);
      setprop("/autopilot/locks/heading", "nav1-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/appr", func (appr){
    var appr = appr.getBoolValue();
    if (appr == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/pitch", 0);
      setprop("/autopilot/locks/altitude", "gs1-hold");
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});


# If trim wheels are not on 0 and you click the center of this wheel
var trimBackTime = 2.0;
var applyTrimWheels = func(v, which = 0) {
    if (which == 0) { interpolate("/controls/flight/elevator-trim", v, trimBackTime); }
    if (which == 1) { interpolate("/controls/flight/rudder-trim", v, trimBackTime); }
    if (which == 2) { interpolate("/controls/flight/aileron-trim", v, trimBackTime); }
}

var switchback = func {
  setprop("/autopilot/switches/gps", 0);
}


