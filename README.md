Barrage
=======
A small domain-specific language for scripting bullet behaviors for shooting games, inspired by [BulletML](http://www.asahi-net.or.jp/~cs8k-cyu/bulletml/index_e.html).

The following is hypothesis, more of a desired end goal if you will.

 - A declarative language defining bullet types and a sequence of events taking place across their lifespan.
 - A particle system wrapper that carries out the events described. 
 
Triggering a Barrage invokes its "initial event", and from there on the game engine must relinquish control of the particle system to the Barrage as it carries out its logic. For this reason, particle systems intended to be used with Barrage must implement some interface to facilitate this.

Barrage scripts can be parsed at runtime from loaded files or (eventually) at compile-time using Haxe macros. The latter approach means any used barrage script would be checked for errors during build and there would be no overhead from interpretation.

Language
========
The following describes a bullet system where the initial action fires a slow bullet towards the player that "bursts" 6 times into a circular spread of more bullets before disappearing. The spawned bullets first spread, then gradually form into "waves" that flow towards the player. 

	# Comments are prefixed with pound sign

	# A Barrage has a starting Action that results in bullets being created
	# Actions can have sub-actions
	# Bullets can trigger actions
	# Actions triggered by bullets use the bullet's position as origin
	
	# Barrage root declaration
	barrage called waveburst
		# Define and name a bullet.
		# This bullet initially moves backwards, but accelerates towards a positive velocity
		bullet called offspring
			speed is -100
			acceleration is 150
			# This bullet action waits a second before turning towards the player
			do action
				wait 1 seconds
				set direction to aimed over 1 seconds
	
		# This is our base bullet
		bullet called source
			speed is 100
			do action
				# This action immediately triggers a sub-action
				do action
					# fires 6 360 degree spreads of 11 bullets, one every quarter second
					wait 0.25 seconds
					# Math expressions in parentheses are evaluated to constants at build time 
					fire offspring in aimed direction (360/10*0.5)
					do action
						fire offspring in incremental direction (360/10)
						repeat 10 times
					repeat 6 times
				# wait for the sub-action to complete..
				wait (6*0.25) seconds
				# then die 
				die
	
		# Barrage entry point. Every barrage must have a start action 
		action called start
			# Fire a source bullet directly towards the player 
			fire source in aimed direction 0


Implementation
========

Barrage as an engine can be considered a "particle governor" in that it needs access to emission and removal functions as well as the properties of each bullet created. Thus, it needs to be mapped against an emitter that implements the IEmitter interface, which needs to return bullets implementing the IBullet interface. When a Barrage is "run", a RunningBarrage instance is created which needs to be updated with an identical delta (in seconds) to the particle system. 

The following example code demonstrates this relationship.

	//Init
	var b = Barrage.fromString(sourceCode); 
	var runningBarrage = b.run(emitter);
	runningBarrage.onComplete.add(onBarrageComplete);
	runningBarrage.start();

	//Update
	runningBarrage.update(deltaSeconds);
	emitter.update(deltaSeconds);

This implementation is still in development. It's necessary for the emitter to be updated separately from the barrage, since an emitter typically won't be exclusive to barrage use.