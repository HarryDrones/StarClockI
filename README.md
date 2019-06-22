# StarClockI
Click the lower left of screen and 3 COP's are drawn in red, green, blue.  These repesent the altitude observed for the stars, Arcturus, Vega, Dubhe.  These circles intersect and that intersection is the position of the observation.  Click the clock button and now youre inside the sphere.  Use the mouse to orient the view.  Use the mouse to align all the visible COP's by dragging in the upper right half of the screen. 

The outer sphere is a NASA image of the entire celestial sphere from this link https://svs.gsfc.nasa.gov/3895
The code for calculating the points of each circle of position are based on code from https://sites.google.com/site/navigationalalgorithms/

Eventually, I want this code to accept input on star name, altitude, time of observation.  This would make the moveable COP's useful in either calculating position, or as a visual ephemeris/planisphere, etc.  As it is right now, it contains redundant code, unused code and abuses the sensibilities of anyone reading it. :D  The upside is it runs. 

For some reason, for my longitude and time of year, I must subtract 1 hour from GAST used to rotateY.  If I do this, it agrees with the orientation of stars in Stellarium and https://staratlas.com/


