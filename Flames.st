Object subclass: #Flames
	instanceVariableNames: 'pal flameArr random front height width poker magnification coolingFactor position '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Flames'!
!Flames commentStamp: '<historical>' prior: 0!
Inspired by a flame-generation algorithm written in C by Evan Jones.
Smalltalk implementation by Jared Ivey.!


!Flames methodsFor: 'initialization' stamp: 'jmi 2/18/2000 18:21'!
extent: aPoint magnifyBy: aScalar

height _ aPoint y.
width _ aPoint x.

magnification _ aScalar.

self initialize.! !

!Flames methodsFor: 'initialization' stamp: 'jmi 2/19/2000 22:15'!
initialize

"basically, a higer cooling factor will make the flame shorter."
coolingFactor _ 2.

position _ 0@0.

"The flame array values are 1 to 256 corresponding to the palette color."

flameArr _ Array2D new width: width height: height type: Array.

"Set all the initial values to black (the first color in the palette)"
1 to: height do: [:y |
	1 to: width do: [:x |
		flameArr at: x at: y put: 0.
	]
].

"Make the random number generator."
random _ Random new.
random initialize.


"Make the palette go from black to red."
pal _ Array new: 256.
0 to: 255 do: [:i |
	pal at: (i+1) put: ((Color r: (1*i/256) g: (0.6*i/256) b: (0.1*i/256)) "pixelValueForDepth: 8").
].

"Create the form to be used when drawing the flames"
front _ ColorForm extent: width@height depth: 8.
front colors: pal.
"front _ Form extent: width@height depth: 8."

"The bit poker!!"
poker _ BitBlt bitPokerToForm: front.
! !


!Flames methodsFor: 'drawing' stamp: 'jmi 2/19/2000 09:05'!
display
	"Display the flames!!  but if no magnification is necessary, don't magnify it.
	 This would needlessly slow it down, and reduce the colors :-\  "

magnification = 1
	ifTrue: [front displayAt: position]
	ifFalse: [(front magnifyBy: magnification) displayAt: position].
! !

!Flames methodsFor: 'drawing' stamp: 'jmi 2/19/2000 00:29'!
drawFlames
	"Put the flames on the screen."

1 to: height do: [:y |
	1 to: width do: [:x |
		"tell the form which color entry to use, and add one to it
		 because squeak freaks out if you try to access the 0th element of an array..."
		front colorAt: x@y put: (pal at: (flameArr at: x at: y)+1).
	]
].
self display.! !

!Flames methodsFor: 'drawing' stamp: 'jmi 2/19/2000 00:30'!
drawFlamesWithBitPoker
	"Poke the flames on the screen."

1 to: height do: [:y |
	1 to: width do: [:x |
			"poke the raw data into the ColorForm."
		poker pixelAt: x@y put: (flameArr at: x at: y).
	]
].
self display.! !


!Flames methodsFor: 'calculation' stamp: 'jmi 2/19/2000 22:11'!
calcAndDrawFlames
"
{ For flame effect scroll through every pixel and  }
{ choose some other pixels around it. Divide by    }
{ the ammount of pixels you added up and then      }
{ subtract a decay ammount.                        }"

| calc |

"randomness to keep the fire going..."
self randomCoals.

"I get an out of bounds error when calculating the edge.  need to do outside the loop"
1 to: (height - 1) do: [:y |
	2 to: (width - 1) do: [:x |
		"Add the surrounding pixels"
		calc _ (flameArr at: x at: y+1)
			 + (flameArr at: x-1 at: y+1)
			 + (flameArr at: x+1 at: y+1)
			 + (flameArr at: x at: y).
		"Average the colors"
		calc _ calc // 4.
		"Subtract the coolingFactor value, if necessary"
		calc > coolingFactor
			ifTrue: [calc _ calc - coolingFactor].
		flameArr at: x at: y put: calc.
		front colorAt: x@y put: (pal at: calc+1).
"		poker pixelAt: x@y put: (flameArr at: x at: y)."

	]
].

self display.
! !

!Flames methodsFor: 'calculation' stamp: 'jmi 2/19/2000 22:12'!
calcAndDrawFlamesWithBitPoker
"
{ For flame effect scroll through every pixel and  }
{ choose some other pixels around it. Divide by    }
{ the ammount of pixels you added up and then      }
{ subtract a decay ammount.                        }"

| calc |

"randomness to keep the fire going..."
self randomCoals.

"I get an out of bounds error when calculating the edge.  need to do outside the loop"
1 to: (height - 1) do: [:y |
	2 to: (width - 1) do: [:x |
		"Add the surrounding pixels"
		calc _ (flameArr at: x at: y+1)
			 + (flameArr at: x-1 at: y+1)
			 + (flameArr at: x+1 at: y+1)
			 + (flameArr at: x at: y).
		"Average the colors"
		calc _ calc // 4.
		"Subtract the coolingFactor value, if necessary"
		calc > coolingFactor
			ifTrue: [calc _ calc - coolingFactor].
		flameArr at: x at: y put: calc.
"		front colorAt: x@y put: (pal at: calc)."
		poker pixelAt: x@y put: calc.
"		poker pixelAt: x@y put: (flameArr at: x at: y)."

	]
].

self display.
! !

!Flames methodsFor: 'calculation' stamp: 'jmi 2/19/2000 22:13'!
calcFlames
"
{ For flame effect scroll through every pixel and  }
{ choose some other pixels around it. Divide by    }
{ the ammount of pixels you added up and then      }
{ subtract a decay ammount.                        }"

| calc |

"randomness to keep the fire going..."
self randomCoals.

"I get an out of bounds error when calculating the edge.  need to do outside the loop"
1 to: (height - 1) do: [:y |
	2 to: (width - 1) do: [:x |
		"Add the surrounding pixels"
		calc _ (flameArr at: x at: y+1)
			 + (flameArr at: x-1 at: y+1)
			 + (flameArr at: x+1 at: y+1)
			 + (flameArr at: x at: y).
		"Average the colors"
		calc _ calc // 4.
		"Subtract the coolingFactor value, if necessary"
		calc > coolingFactor
			ifTrue: [calc _ calc - coolingFactor].
		flameArr at: x at: y put: calc.
	]
].
! !

!Flames methodsFor: 'calculation' stamp: 'jmi 2/19/2000 22:13'!
calcFlamesAlternate
"
{ For flame effect scroll through every pixel and  }
{ choose some other pixels around it. Divide by    }
{ the ammount of pixels you added up and then      }
{ subtract a decay ammount.                        }"

| calc |

"randomness to keep the fire going..."
self randomCoals.

"I get an out of bounds error when calculating the edge.  need to do outside the loop"
1 to: (height - 1) do: [:y |
	2 to: (width - 1) do: [:x |
		"Add the surrounding pixels"
		calc _ (flameArr at: x at: y+1)
			 + (flameArr at: x-1 at: y+1)
			 + (flameArr at: x+1 at: y+1)
"			 + (flameArr at: x at: y)".
		"Average the colors"
		calc _ calc // 3.
		"Subtract the coolingFactor value, if necessary"
		calc > coolingFactor
			ifTrue: [calc _ calc - coolingFactor].
		flameArr at: x at: y put: calc.
	]
].
! !

!Flames methodsFor: 'calculation' stamp: 'jmi 2/19/2000 22:13'!
calcFlamesAlternate2
"
{ For flame effect scroll through every pixel and  }
{ choose some other pixels around it. Divide by    }
{ the ammount of pixels you added up and then      }
{ subtract a decay ammount.                        }"

| calc |

"randomness to keep the fire going..."
self randomCoals.

"I get an out of bounds error when calculating the edge.  need to do outside the loop"
1 to: (height - 1) do: [:y |
	2 to: (width - 1) do: [:x |
		"Add the surrounding pixels"
		calc _ "(flameArr at: x at: y+1)
			 +" (flameArr at: x-1 at: y+1)
			 + (flameArr at: x+1 at: y+1)"
			 + (flameArr at: x at: y)".
		"Average the colors"
		calc _ calc // 2.
		"Subtract the coolingFactor value"
		calc > coolingFactor
			ifTrue: [calc _ calc - coolingFactor].
		flameArr at: x at: y put: calc.
	]
].

! !

!Flames methodsFor: 'calculation' stamp: 'jmi 2/19/2000 00:08'!
randomCoals
	"Set the next row of random coals to keep the fire going."

1 to: width do: [:x |
"	flameArr at: x at: height put: ((random next * 255 + 1) asInteger)."

"Force the coals to be a little brighter"
	flameArr at: x at: height put: ((random next * 200 + 54) asInteger).
].
! !


!Flames methodsFor: 'accessing' stamp: 'jmi 2/19/2000 20:41'!
palette: aPalette
	"Sets the palette"

pal _ aPalette.
front colors: aPalette.! !

!Flames methodsFor: 'accessing' stamp: 'jmi 2/19/2000 09:04'!
position
	"Answer the Flame position"

^position.! !

!Flames methodsFor: 'accessing' stamp: 'jmi 2/19/2000 09:05'!
position: aPoint
	"Set the Flame position"

position _ aPoint.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Flames class
	instanceVariableNames: ''!

!Flames class methodsFor: 'instance creation' stamp: 'jmi 2/19/2000 22:15'!
default
	"These seemed to be good defaults for me."

"Note: if magnification is used, the number of colors is reduced.  This happens as a result of the way the form is resized."

^Flames extent: 50@50 magnifyBy: 1.
"set magnification to 1 to keep all the colors"

"^Flames extent: 50@30 magnifyBy: 1."
"^Flames extent: 16@32 magnifyBy: 4."
"^Flames extent: 25@25 magnifyBy: 4."
! !

!Flames class methodsFor: 'instance creation' stamp: 'jmi 2/18/2000 20:11'!
extent: aPoint magnifyBy: aScalar

^(Flames new extent: aPoint magnifyBy: aScalar) initialize.
! !


!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 22:14'!
examples

"examples is meant to hold lines of code that can be run individually"

false ifTrue: [^self error: 'don''t run Flames example, run Flames test#']
"I figured this would be nicer, since the pink box might confuse some people"
ifFalse: [^FillInTheBlank
			request: 'Don''t run ''Flames examples'''
			initialAnswer: 'Open it in a browser, or run the Flames test methods'].

Flames test1.
Flames test2.
Flames test3.
Flames test4.


"Just place the cursor on a line below and press alt+d"

Flames test2extent: 50@50 magnifyBy: 1 color: Color orange. "the default value"
Flames test2extent: 50@40 magnifyBy: 1 color: Color orange.
Flames test2extent: 50@40 magnifyBy: 1.000001 color: Color orange.
Flames test2extent: 32@32 magnifyBy: 1 color: Color green.
Flames test2extent: 16@40 magnifyBy: 2 color: Color yellow.
Flames test2extent: 24@24 magnifyBy: 4 color: Color red.
Flames test2extent: 8@16 magnifyBy: 1 color: Color lightOrange.
Flames test2extent: 192@12 magnifyBy: 3 color: Color magenta.
Flames test2extent: 14@32 magnifyBy: 8 color: Color yellow.

"Here's all the colors so you don't have to type them in individually"
Flames test2extent: 32@32 magnifyBy: 1 color: Color brown.
Flames test2extent: 32@32 magnifyBy: 1 color: Color cyan.
Flames test2extent: 32@32 magnifyBy: 1 color: Color darkGray.
Flames test2extent: 32@32 magnifyBy: 1 color: Color gray.
Flames test2extent: 32@32 magnifyBy: 1 color: Color green.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightBlue.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightBrown.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightCyan.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightGray.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightGreen.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightMagenta.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightOrange.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightRed.
Flames test2extent: 32@32 magnifyBy: 1 color: Color lightYellow.
Flames test2extent: 32@32 magnifyBy: 1 color: Color magenta.
Flames test2extent: 32@32 magnifyBy: 1 color: Color orange.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleBlue.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleBuff.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleGreen.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleMagenta.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleOrange.
Flames test2extent: 32@32 magnifyBy: 1 color: Color palePeach.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleRed.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleTan.
Flames test2extent: 32@32 magnifyBy: 1 color: Color paleYellow.
Flames test2extent: 32@32 magnifyBy: 1 color: Color red.
Flames test2extent: 32@32 magnifyBy: 1 color: Color tan.
Flames test2extent: 32@32 magnifyBy: 1 color: Color veryDarkGray.
Flames test2extent: 32@32 magnifyBy: 1 color: Color veryLightGray.


! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/18/2000 21:34'!
test1
	"This was my first try to get this to work"

| flame |

flame _ Flames default.

[Sensor anyButtonPressed] whileFalse: [
	flame calcFlames.
	flame drawFlames.
].! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 00:17'!
test2
	"This was my first try to get this to work, with a BitPoker =)"

| flame |

flame _ Flames default.

[Sensor anyButtonPressed] whileFalse: [
	flame calcFlames.
	flame drawFlamesWithBitPoker.
].! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 22:02'!
test2extent: aPoint magnifyBy: aScalar color: aColor
	"This is the best of the 4, so this is what I used for the varying flames in Flames examples"

| flame palette r g b |

flame _ Flames extent: aPoint magnifyBy: aScalar.

r _ aColor red.
g _ aColor green.
b _ aColor blue.

palette _ Array new: 256.
0 to: 255 do: [:i |
	palette at: (i+1) put: ((Color r: (r*i/256) g: (g*i/256) b: (b*i/256)) "pixelValueForDepth: 8").
].

flame palette: palette.

[Sensor anyButtonPressed] whileFalse: [
	flame calcFlames.
	flame drawFlamesWithBitPoker.
].! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 00:17'!
test3
	"This version has one pixel removed from the average."

| flame |

flame _ Flames default.

[Sensor anyButtonPressed] whileFalse: [
	flame calcFlamesAlternate.
	flame drawFlamesWithBitPoker.
].! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 00:18'!
test4
	"This version has two pixels removed from the average."

| flame |

flame _ Flames default.

[Sensor anyButtonPressed] whileFalse: [
	flame calcFlamesAlternate2.
	flame drawFlamesWithBitPoker.
].! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 00:20'!
test8
	"This version has the drawing code inside the calculation loop to see if that speeds it up."
	"Answer: no, drawing from inside the loop serves no real speed advantage."

| flame |

flame _ Flames default.

[Sensor anyButtonPressed] whileFalse: [
	flame calcAndDrawFlames.
].! !

!Flames class methodsFor: 'examples' stamp: 'jmi 2/19/2000 00:21'!
test9
	"This version has the drawing code inside the calculation loop to see if that speeds it up."
	"Answer: no, the speed is from the BitPoker alone."

| flame |

flame _ Flames default.

[Sensor anyButtonPressed] whileFalse: [
	flame calcAndDrawFlamesWithBitPoker.
].! !
