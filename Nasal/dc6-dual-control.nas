###############################################################################
##  Nasal for dual control of the Common-Spruce CS 1 over the multiplayer network.
##
##  Copyright (C) 2007 - 2008  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license version 2 or later.
##
##  For the CS 1, written in January 2012 by Marc Kraus
##
###############################################################################

## Renaming (almost :)
var DCT = dual_control_tools;

## Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/dc6/Models/DC-6B.xml";
var copilot_type = "Aircraft/dc6/Models/DC-6B-Copilot.xml";

############################ PROPERTIES MP ###########################

#####
# pilot properties
##
var rpm              = ["engines/engine/rpm", "engines/engine[1]/rpm", "engines/engine[2]/rpm", "engines/engine[3]/rpm"];

var gear             = "gear/gear[0]/position-norm";

var lights_mpp       = "sim/multiplay/generic/int[0]";
var TDM_mpp1         = "sim/multiplay/generic/string[0]";
var TDM_mpp2         = "sim/multiplay/generic/string[1]";


######################################################################
# Useful instrument related property paths.

# Engine controls
var magnetos_cmd      = "controls/engines/engine/magnetos";
var rpm_cmd           = ["engines/engine/rpm", "engines/engine[1]/rpm", "engines/engine[2]/rpm", "engines/engine[3]/rpm"];

var FDM=getprop("sim/flight-model") or "nix";
if(FDM=="jsb"){
  var bmep_cmd    = ["fdm/jsbsim/propulsion/engine[0]/power-hp", 
                     "fdm/jsbsim/propulsion/engine[1]/power-hp", 
                     "fdm/jsbsim/propulsion/engine[2]/power-hp", 
                     "fdm/jsbsim/propulsion/engine[3]/power-hp"];
}else{
  var bmep_cmd    = ["engines/engine/torque-ftlb", 
                     "engines/engine[1]/torque-ftlb", 
                     "engines/engine[2]/torque-ftlb", 
                     "engines/engine[3]/torque-ftlb"];
}

# Sound
var gear_cmd          = "gear/gear[0]/position-norm";

# FlightRalleyWatch
var frw_cmd           = ["instrumentation/frw/flight-time/hours", 
                         "instrumentation/frw/flight-time/minutes", 
                         "instrumentation/frw/flight-time/seconds"];

# Other controls
var comm_cmd          = ["instrumentation/comm/frequencies/selected-mhz", 
                         "instrumentation/comm/frequencies/standby-mhz",
                         "instrumentation/comm[1]/frequencies/selected-mhz", 
                         "instrumentation/comm[1]/frequencies/standby-mhz"];

var nav_cmd           = ["instrumentation/nav/frequencies/selected-mhz", 
                         "instrumentation/nav/frequencies/standby-mhz",
                         "instrumentation/nav[1]/frequencies/selected-mhz", 
                         "instrumentation/nav[1]/frequencies/standby-mhz"];

var adf_cmd           = ["instrumentation/adf/frequencies/selected-khz",
                         "instrumentation/adf/frequencies/standby-khz",
                         "instrumentation/adf[1]/frequencies/selected-khz", 
                         "instrumentation/adf[1]/frequencies/standby-khz"];

var tank_cmd          = ["consumables/fuel/tank/level-gal_us", 
                         "consumables/fuel/tank[1]/level-gal_us", 
                         "consumables/fuel/tank[2]/level-gal_us", 
                         "consumables/fuel/tank[3]/level-gal_us",
                         "consumables/fuel/tank[4]/level-gal_us", 
                         "consumables/fuel/tank[5]/level-gal_us", 
                         "consumables/fuel/tank[6]/level-gal_us", 
                         "consumables/fuel/tank[7]/level-gal_us"];


var instr_cmd         = ["instrumentation/nav/radials/selected-deg",
                         "instrumentation/nav[1]/radials/selected-deg",
                         "instrumentation/altimeter/setting-inhg", 
                         "instrumentation/heading-indicator/offset-deg",
                         "instrumentation/altimeter/setting-inhg",
                         "autopilot/settings/target-speed-kt", 
                         "autopilot/settings/target-pitch-deg", 
                         "autopilot/settings/target-altitude-ft", 
                         "autopilot/settings/vertical-speed-fpm",
                         "autopilot/settings/heading-bug-deg"];


var agl_cmd           = ["position/gear-agl-ft", "position/gear-agl-m"];

var batt_switch       = "controls/electric/battery-switch";
var nav_lights        = "controls/lighting/nav-lights";
var strobe_switch     = "controls/lighting/strobe";


# Boolean properties
var running        = ["engines/engine[0]/running", "engines/engine[1]/running", "engines/engine[2]/running", "engines/engine[3]/running"];
var cranking       = ["engines/engine[0]/cranking", "engines/engine[1]/cranking", "engines/engine[2]/cranking", "engines/engine[3]/cranking"];
var brake_parking  = "controls/gear/brake-parking";
var gear_wow       = ["gear/gear[0]/wow", "gear/gear[1]/wow", "gear/gear[2]/wow"];

var ap_switch      = ["autopilot/switches/alt",
                      "autopilot/switches/ap",
                      "autopilot/switches/appr",
                      "autopilot/switches/gps",
                      "autopilot/switches/hdg",
                      "autopilot/switches/ias",
                      "autopilot/switches/nav",
                      "autopilot/switches/pitch"];

var l_dual_control    = "dual-control/active";

######################################################################
###### Used by dual_control to set up the mappings for the pilot #####
######################## PILOT TO COPILOT ############################
######################################################################

var pilot_connect_copilot = func (copilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Pilot section");
  setprop(l_dual_control, 1);

  return [
      ##################################################
      # Map copilot properties to buffer properties

      # copilot to pilot

      DCT.TDMEncoder.new
        ([
          props.globals.getNode(magnetos_cmd),
          props.globals.getNode(nav_cmd[0]),
          props.globals.getNode(nav_cmd[1]),
          props.globals.getNode(nav_cmd[2]),
          props.globals.getNode(nav_cmd[3]),
          props.globals.getNode(comm_cmd[0]),
          props.globals.getNode(comm_cmd[1]),
          props.globals.getNode(comm_cmd[2]),
          props.globals.getNode(comm_cmd[3]),
          props.globals.getNode(adf_cmd[0]),
          props.globals.getNode(adf_cmd[1]),
          props.globals.getNode(adf_cmd[2]),
          props.globals.getNode(adf_cmd[3]),
          props.globals.getNode(instr_cmd[0]),
          props.globals.getNode(instr_cmd[1]),
          props.globals.getNode(instr_cmd[2]),
          props.globals.getNode(instr_cmd[3]),
          props.globals.getNode(instr_cmd[4]),
          props.globals.getNode(instr_cmd[5]),
          props.globals.getNode(instr_cmd[6]),
          props.globals.getNode(instr_cmd[7]),
          props.globals.getNode(instr_cmd[8]),
          props.globals.getNode(instr_cmd[9])
         ], props.globals.getNode(TDM_mpp1)),      
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(tank_cmd[0]),
          props.globals.getNode(tank_cmd[1]),
          props.globals.getNode(tank_cmd[2]),
          props.globals.getNode(tank_cmd[3]),
          props.globals.getNode(tank_cmd[4]),
          props.globals.getNode(tank_cmd[5]),
          props.globals.getNode(tank_cmd[6]),
          props.globals.getNode(tank_cmd[7]),
          props.globals.getNode(bmep_cmd[0]),
          props.globals.getNode(bmep_cmd[1]),
          props.globals.getNode(bmep_cmd[2]),
          props.globals.getNode(bmep_cmd[3]),
          props.globals.getNode(frw_cmd[0]),
          props.globals.getNode(frw_cmd[1]),
          props.globals.getNode(frw_cmd[2]),
          props.globals.getNode(agl_cmd[0]),
          props.globals.getNode(agl_cmd[1])
         ], props.globals.getNode(TDM_mpp2)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(batt_switch),
          props.globals.getNode(nav_lights),
          props.globals.getNode(strobe_switch),
          props.globals.getNode(running[0]),
          props.globals.getNode(running[1]),
          props.globals.getNode(running[2]),
          props.globals.getNode(running[3]),
          props.globals.getNode(cranking[0]),
          props.globals.getNode(cranking[1]),
          props.globals.getNode(cranking[2]),
          props.globals.getNode(cranking[3]),
          props.globals.getNode(ap_switch[0]),
          props.globals.getNode(ap_switch[1]),
          props.globals.getNode(ap_switch[2]),
          props.globals.getNode(ap_switch[3]),
          props.globals.getNode(ap_switch[4]),
          props.globals.getNode(ap_switch[5]),
          props.globals.getNode(ap_switch[6]),
          props.globals.getNode(ap_switch[7])
         ], props.globals.getNode(lights_mpp)),

  ];
}

##############
var pilot_disconnect_copilot = func {
  setprop(l_dual_control, 0);
}

######################################################################
##### Used by dual_control to set up the mappings for the copilot ####
######################## COPILOT TO PILOT ############################
######################################################################

var copilot_connect_pilot = func (pilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Copilot section");
  setprop(l_dual_control, 1);

  return [

      ##################################################
      # Map pilot properties to buffer properties

      DCT.Translator.new(pilot.getNode(rpm[0]), props.globals.getNode(rpm_cmd[0], 1)),
      DCT.Translator.new(pilot.getNode(rpm[1]), props.globals.getNode(rpm_cmd[1], 1)),
      DCT.Translator.new(pilot.getNode(rpm[2]), props.globals.getNode(rpm_cmd[2], 1)),
      DCT.Translator.new(pilot.getNode(rpm[3]), props.globals.getNode(rpm_cmd[3], 1)),
      DCT.Translator.new(pilot.getNode(gear), props.globals.getNode(gear_cmd, 1)),
      ##################################################
      # Map pilot properties to buffer properties
      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp1), 
        [func(v){pilot.getNode(magnetos_cmd, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd, 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[4], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[4], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[5], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[5], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[6], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[6], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[7], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[7], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[8], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[8], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[9], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[9], 1).setValue(v);},
        ]),

      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp2), 
        [
         func(v){pilot.getNode(tank_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[4], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[4], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[5], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[5], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[6], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[6], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[7], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[7], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(frw_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~frw_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(frw_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~frw_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(frw_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~frw_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(agl_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~agl_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(agl_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~agl_cmd[1], 1).setValue(v);},
        ]),

      DCT.SwitchDecoder.new
        (pilot.getNode(lights_mpp),
        [func(b){props.globals.getNode(batt_switch).setValue(b);},
         func(b){props.globals.getNode(nav_lights).setValue(b);},
         func(b){props.globals.getNode(strobe_switch).setValue(b);},
         func(b){props.globals.getNode(running[0]).setValue(b);},
         func(b){props.globals.getNode(running[1]).setValue(b);},
         func(b){props.globals.getNode(running[2]).setValue(b);},
         func(b){props.globals.getNode(running[3]).setValue(b);},
         func(b){props.globals.getNode(cranking[0]).setValue(b);},
         func(b){props.globals.getNode(cranking[1]).setValue(b);},
         func(b){props.globals.getNode(cranking[2]).setValue(b);},
         func(b){props.globals.getNode(cranking[3]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[0]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[1]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[2]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[3]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[4]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[5]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[6]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[7]).setValue(b);},
        ]),

      ##################################################
      # Animation of the knobs and more
      
      # copilot to pilot

      # lights_mpp
      DCT.Translator.new(props.globals.getNode(batt_switch, 1), pilot.getNode("/"~batt_switch)),
      DCT.Translator.new(props.globals.getNode(nav_lights, 1), pilot.getNode("/"~nav_lights)),
      DCT.Translator.new(props.globals.getNode(strobe_switch, 1), pilot.getNode("/"~strobe_switch)),
      DCT.Translator.new(props.globals.getNode(running[0], 1), pilot.getNode("/"~running[0])),
      DCT.Translator.new(props.globals.getNode(running[1], 1), pilot.getNode("/"~running[1])),
      DCT.Translator.new(props.globals.getNode(running[2], 1), pilot.getNode("/"~running[2])),
      DCT.Translator.new(props.globals.getNode(running[3], 1), pilot.getNode("/"~running[3])),
      DCT.Translator.new(props.globals.getNode(cranking[0], 1), pilot.getNode("/"~cranking[0])),
      DCT.Translator.new(props.globals.getNode(cranking[1], 1), pilot.getNode("/"~cranking[1])),
      DCT.Translator.new(props.globals.getNode(cranking[2], 1), pilot.getNode("/"~cranking[2])),
      DCT.Translator.new(props.globals.getNode(cranking[3], 1), pilot.getNode("/"~cranking[3])),
      DCT.Translator.new(props.globals.getNode(ap_switch[0], 1), pilot.getNode("/"~ap_switch[0])),
      DCT.Translator.new(props.globals.getNode(ap_switch[1], 1), pilot.getNode("/"~ap_switch[1])),
      DCT.Translator.new(props.globals.getNode(ap_switch[2], 1), pilot.getNode("/"~ap_switch[2])),
      DCT.Translator.new(props.globals.getNode(ap_switch[3], 1), pilot.getNode("/"~ap_switch[3])),
      DCT.Translator.new(props.globals.getNode(ap_switch[4], 1), pilot.getNode("/"~ap_switch[4])),
      DCT.Translator.new(props.globals.getNode(ap_switch[5], 1), pilot.getNode("/"~ap_switch[5])),
      DCT.Translator.new(props.globals.getNode(ap_switch[6], 1), pilot.getNode("/"~ap_switch[6])),
      DCT.Translator.new(props.globals.getNode(ap_switch[7], 1), pilot.getNode("/"~ap_switch[7])),
      # TDM_mpp1
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd, 1), props.globals.getNode(magnetos_cmd), props.globals.getNode(magnetos_cmd), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[0], 1), props.globals.getNode(nav_cmd[0]), props.globals.getNode(nav_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[1], 1), props.globals.getNode(nav_cmd[1]), props.globals.getNode(nav_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[2], 1), props.globals.getNode(nav_cmd[2]), props.globals.getNode(nav_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[3], 1), props.globals.getNode(nav_cmd[3]), props.globals.getNode(nav_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[0], 1), props.globals.getNode(comm_cmd[0]), props.globals.getNode(comm_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[1], 1), props.globals.getNode(comm_cmd[1]), props.globals.getNode(comm_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[2], 1), props.globals.getNode(comm_cmd[2]), props.globals.getNode(comm_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[3], 1), props.globals.getNode(comm_cmd[3]), props.globals.getNode(comm_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[0], 1), props.globals.getNode(adf_cmd[0]), props.globals.getNode(adf_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[1], 1), props.globals.getNode(adf_cmd[1]), props.globals.getNode(adf_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[2], 1), props.globals.getNode(adf_cmd[2]), props.globals.getNode(adf_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[3], 1), props.globals.getNode(adf_cmd[3]), props.globals.getNode(adf_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[0], 1), props.globals.getNode(instr_cmd[0]), props.globals.getNode(instr_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[1], 1), props.globals.getNode(instr_cmd[1]), props.globals.getNode(instr_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[2], 1), props.globals.getNode(instr_cmd[2]), props.globals.getNode(instr_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[3], 1), props.globals.getNode(instr_cmd[3]), props.globals.getNode(instr_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[4], 1), props.globals.getNode(instr_cmd[4]), props.globals.getNode(instr_cmd[4]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[5], 1), props.globals.getNode(instr_cmd[5]), props.globals.getNode(instr_cmd[5]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[6], 1), props.globals.getNode(instr_cmd[6]), props.globals.getNode(instr_cmd[6]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[7], 1), props.globals.getNode(instr_cmd[7]), props.globals.getNode(instr_cmd[7]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[8], 1), props.globals.getNode(instr_cmd[8]), props.globals.getNode(instr_cmd[8]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[9], 1), props.globals.getNode(instr_cmd[9]), props.globals.getNode(instr_cmd[9]), 0.01),
      # TDM_mpp2
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[0], 1), props.globals.getNode(tank_cmd[0]), props.globals.getNode(tank_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[1], 1), props.globals.getNode(tank_cmd[1]), props.globals.getNode(tank_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[2], 1), props.globals.getNode(tank_cmd[2]), props.globals.getNode(tank_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[3], 1), props.globals.getNode(tank_cmd[3]), props.globals.getNode(tank_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[4], 1), props.globals.getNode(tank_cmd[4]), props.globals.getNode(tank_cmd[4]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[5], 1), props.globals.getNode(tank_cmd[5]), props.globals.getNode(tank_cmd[5]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[6], 1), props.globals.getNode(tank_cmd[6]), props.globals.getNode(tank_cmd[6]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[7], 1), props.globals.getNode(tank_cmd[7]), props.globals.getNode(tank_cmd[7]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[0], 1), props.globals.getNode(bmep_cmd[0]), props.globals.getNode(bmep_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[1], 1), props.globals.getNode(bmep_cmd[1]), props.globals.getNode(bmep_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[2], 1), props.globals.getNode(bmep_cmd[2]), props.globals.getNode(bmep_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[3], 1), props.globals.getNode(bmep_cmd[3]), props.globals.getNode(bmep_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~frw_cmd[0], 1), props.globals.getNode(frw_cmd[0]), props.globals.getNode(frw_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~frw_cmd[1], 1), props.globals.getNode(frw_cmd[1]), props.globals.getNode(frw_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~frw_cmd[2], 1), props.globals.getNode(frw_cmd[2]), props.globals.getNode(frw_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~agl_cmd[0], 1), props.globals.getNode(agl_cmd[0]), props.globals.getNode(agl_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~agl_cmd[1], 1), props.globals.getNode(agl_cmd[1]), props.globals.getNode(agl_cmd[1]), 0.01),
  ];

}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
