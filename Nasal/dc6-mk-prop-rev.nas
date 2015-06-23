# for yasim help with the pushback function 

var proprev_enable	= props.globals.getNode("/controls/engines/reverser_allow");
var proprev_controls	= props.globals.getNode("/engines/engine[0]/running");


setlistener("/controls/engines/engine[0]/throttle", func(throttle) {
    var throttle = throttle.getValue();
    if (proprev_enable.getBoolValue()) {
      setprop("/sim/model/pushback/target-speed-fps", -throttle );
    }
});



# Enabled , disabled prop reverser 
toggle_reverse_lockout = func {
  if (!proprev_enable.getValue()) {					# Disabled, toggle to enable
    proprev_enable.setValue(1);
     props.globals.getNode("/sim/model/pushback/enabled", 1 ).setBoolValue(1);
     props.globals.initNode("/sim/model/pushback/target-speed-fps", 0.0  );
     setprop("/sim/model/pushback/force", 1);

    dc6b.switch5SoundToggle();
  } else {						
    proprev_enable.setValue(0);
     setprop("/sim/model/pushback/enabled", 0 );
     setprop("/sim/model/pushback/target-speed-fps", 0 );
     setprop("/sim/model/pushback/force", 0);

    dc6b.switch5SoundToggle();
  }
}

# pitch set to 0 and set throttle as target-speed-fps
toggle_prop_reverse = func {
  if (!proprev_enable.getValue()) { return; }				# Can't toggle reverse if locked out
  if (proprev_controls.getValue()) {		# Using eng 1 as master

      if(getprop("controls/engines/engine[0]/propeller-pitch") == 1){
        setprop("controls/engines/engine[0]/propeller-pitch", 0);
        setprop("controls/engines/engine[1]/propeller-pitch", 0);
        setprop("controls/engines/engine[2]/propeller-pitch", 0);
        setprop("controls/engines/engine[3]/propeller-pitch", 0);
        dc6b.switch6SoundToggle();
      }else{
        setprop("controls/engines/engine[0]/propeller-pitch", 1);
        setprop("controls/engines/engine[1]/propeller-pitch", 1);
        setprop("controls/engines/engine[2]/propeller-pitch", 1);
        setprop("controls/engines/engine[3]/propeller-pitch", 1);
        dc6b.switch6SoundToggle();
      }

  }
}
