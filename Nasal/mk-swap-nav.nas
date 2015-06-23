setlistener("/instrumentation/deviation-indicator/frequency", func (state){
    var state = state.getValue();
    if (state == 1){
      settimer(gonnaBack,0.5);

      ## animate a smooth changing on the both nav instruments
      var nav0radial = getprop("/instrumentation/nav[0]/radials/selected-deg");
      var nav1radial = getprop("/instrumentation/nav[1]/radials/selected-deg");

      var t = 2.0;
      interpolate("/instrumentation/nav[0]/radials/selected-deg", nav1radial, t);
      interpolate("/instrumentation/nav[1]/radials/selected-deg", nav0radial, t);
    }
});

var gonnaBack = func {
  setprop("/instrumentation/deviation-indicator/frequency", 0);
};

