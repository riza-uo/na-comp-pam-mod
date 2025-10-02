messages()
//
// Originally from rudedog's message center for CoD Version 1.2.1
// 

{

	// Make sure the server runs even if message center is not set up.
if(getcvar("sv_message1") == "")
	setcvar("sv_message1", "*none*");
if(getcvar("sv_message2") == "")
	setcvar("sv_message2", "*none*");
if(getcvar("sv_message3") == "")
	setcvar("sv_message3", "*none*");
if(getcvar("sv_message4") == "")
	setcvar("sv_message4", "*none*");
if(getcvar("sv_message5") == "")
	setcvar("sv_message5", "*none*");
if(getcvar("sv_message6") == "")
	setcvar("sv_message6", "*none*");
if(getcvar("sv_message7") == "")
	setcvar("sv_message7", "*none*");
if(getcvar("sv_message8") == "")
	setcvar("sv_message8", "*none*");
if(getcvar("sv_message9") == "")
	setcvar("sv_message9", "*none*");

if(getcvar("sv_message1delay") == "")
	setcvar("sv_message1delay", "-1");
if(getcvar("sv_message2delay") == "")
	setcvar("sv_message2delay", "-1");
if(getcvar("sv_message3delay") == "")
	setcvar("sv_message3delay", "-1");
if(getcvar("sv_message4delay") == "")
	setcvar("sv_message4delay", "-1");
if(getcvar("sv_message5delay") == "")
	setcvar("sv_message5delay", "-1");
if(getcvar("sv_message6delay") == "")
	setcvar("sv_message6delay", "-1");
if(getcvar("sv_message7delay") == "")
	setcvar("sv_message7delay", "-1");
if(getcvar("sv_message8delay") == "")
	setcvar("sv_message8delay", "-1");
if(getcvar("sv_message9delay") == "")
	setcvar("sv_message9delay", "-1");

	

if(getcvar("sv_msgdelay") == "")
	setcvar("sv_msgdelay", "20"); //Delay between messages in seconds


	// print to screen
	print_text();

}

// print to screen
print_text()
{
	for (;;)
	{
		msg_delay = getcvarint("sv_msgdelay"); // set delay timer
		msg_delay1 = getcvarint("sv_message1delay");
		msg_delay2 = getcvarint("sv_message2delay");
		msg_delay3 = getcvarint("sv_message3delay");
		msg_delay4 = getcvarint("sv_message4delay");
		msg_delay5 = getcvarint("sv_message5delay");
		msg_delay6 = getcvarint("sv_message6delay");
		msg_delay7 = getcvarint("sv_message7delay");
		msg_delay8 = getcvarint("sv_message8delay");
		msg_delay9 = getcvarint("sv_message9delay");

		if (msg_delay < 2) setcvar("msg_delay", "6"); // check timer is over 2 seconds

		if (getcvar("sv_message1") != "*none*")
		{
			svmessage = getcvar("sv_message1"); // set message
			iprintln(svmessage); // print message 1
			if (msg_delay1 > -1)
				wait msg_delay1;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message2") != "*none*")
		{
			svmessage = getcvar("sv_message2"); // set message
			iprintln(svmessage); // print message 2
			if (msg_delay2 > -1)
				wait msg_delay2;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message3") != "*none*")
		{
			svmessage = getcvar("sv_message3"); // set message
			iprintln(svmessage); // print message 3
			if (msg_delay3 > -1)
				wait msg_delay3;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message4") != "*none*")
		{
			svmessage = getcvar("sv_message4"); // set message
			iprintln(svmessage); // print message 4
			if (msg_delay4 > -1)
				wait msg_delay4;
			else
				wait msg_delay;
		}


		if (getcvar("sv_message5") != "*none*")
		{
			svmessage = getcvar("sv_message5"); // set message
			iprintln(svmessage); // print message 5
			if (msg_delay5 > -1)
				wait msg_delay5;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message6") != "*none*")
		{
			svmessage = getcvar("sv_message6"); // set message
			iprintln(svmessage); // print message 6
			if (msg_delay6 > -1)
				wait msg_delay6;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message7") != "*none*")
		{
			svmessage = getcvar("sv_message7"); // set message
			iprintln(svmessage); // print message 7
			if (msg_delay7 > -1)
				wait msg_delay7;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message8") != "*none*")
		{
			svmessage = getcvar("sv_message8"); // set message
			iprintln(svmessage); // print message 8
			if (msg_delay8 > -1)
				wait msg_delay8;
			else
				wait msg_delay;
		}

		if (getcvar("sv_message9") != "*none*")
		{
			svmessage = getcvar("sv_message9"); // set message
			iprintln(svmessage); // print message 9
			if (msg_delay9 > -1)
				wait msg_delay9;
			else
				wait msg_delay;
		}
		
		wait .5;
	}
}
