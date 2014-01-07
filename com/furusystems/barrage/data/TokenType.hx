package com.furusystems.barrage.data;

/**
 * ...
 * @author Andreas Rønning
 */
enum TokenType
{
	horizontal_token;
	vertical_token;
	barrage_token;
	speed_token;
	fire_token;
	identifier_token;
	do_token;
	script_token;
	const_math_token;
	number_token;
	direction_token;
	sequential_token;
	absolute_token;
	aimed_token;
	relative_token;
	frames_token;
	seconds_token;
	start_token;
	vanish_token;
	over_token;
	set_token;
	bullet_token;
	action_token;
	
	//ignored tokens
	ignored;
	//called_token;
	//at_token;
	//in_token;
	//then_token;
	//is_token;
	//to_token;
	//times_token;
	
}