Barrage
=======
A small domain-specific language for scripting bullet behaviors for shooting games, inspired by [BulletML](http://www.asahi-net.or.jp/~cs8k-cyu/bulletml/index_e.html).

The following is hypothesis, more of a desired end goal if you will.

 - A declarative language defining bullet types and a sequence of events taking place across their lifespan.
 - A particle system wrapper that carries out the events described. 
 
Triggering a Barrage invokes its "initial event", and from there on the game engine must relinquish control of the particle system to the Barrage as it carries out its logic. For this reason, particle systems intended to be used with Barrage must implement some interface to facilitate this.

Barrage scripts can be parsed at runtime from loaded files or at compile-time using Haxe macros. The latter approach means any used barrage script would be checked for errors during build and there will be no overhead from interpretation.

Language
========
The following describes a bullet system where the initial action fires a linear spread of "seed" bullets, which decelerate over time until they each erupt into a new set of bullets, where each fired bullet is slightly faster than the previous.

	# Comments are prefixed with pound sign
	
	# A Barrage has a starting Action that results in bullets being created
	# Actions can have sub-actions
	# Bullets can trigger actions
	# Actions triggered by bullets use the bullet's position as origin
	
	# First define the base identity and orientation of this barrage
	barrage called boss_grow_bullets
		# Define and name a bullet
		# bullets can be left anonymous if no referencing is required
		bullet called seed
			# Initial properties are speed and acceleration.
			# Acceleration defaults to 0
			speed is 1.2
			# "do" blocks trigger an action, named or anonymous
			# action blocks list events taking place sequentially
			do action
				# speed and acceleration are common bullet properties
				# "over" keyword allows for temporal spread
				set speed to 0 over 60 frames
				# frames and seconds are valid values
				wait 60 frames
				# "fire" blocks take a named bullet or an anonymous "bullet"
				fire bullet at absolute speed 0.75
				do action
					fire bullet at sequential speed 0.15 in aimed direction
					# repeat blocks cause actions to retrigger (duh)
					# all commands in parentheses are parsed to hscript
					# hscript values are executed at runtime
					# if no variables are used, the result is made constant
					repeat (4 * difficulty * 4) times
				# vanish block causes a bullet to immediately die
				vanish
	
		# Define the starting action (barrage invalid if undefined)
		# named actions are manually predefined
		action called start
			# fire a named bullet
			fire seed in absolute direction (270 - 4 + difficulty * 6 * 15 * 0.5)
			do action
				# sequential direction applies a flat modifier to the previous 
				# direction fired at within this action tree. 
				fire seed in sequential direction 15 
			repeat (4 + difficulty * 6) times