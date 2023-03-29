Server is a custom packet server built using Indy compiled with Delphi 11
Using Zeos for the Firebird database access.

Each Nard has it's own connection to DB.
Server can request values to be sent and set.
Nards can set and log and set vars.

Each Nard is programmed with unique id has a corrosponding db record.

Multiple screen items can be attached to one nard, displaying different values.
Each screen item currently has 2 values and a name that can be programmed.
Of course pics are all programmmable and need to be in the image folder located inside executable folder.

What you need?
Install firebird 3 server.
the SYSDBA password expected is qubits but this can be changed to whatever.
You'll get an error connecting to db, goto file->server->config and set the password, restart app.

you need a database, i've provided a script to create a new and also my current test db.
put your db where ever you like, then edit the firebird databaes.conf and add<br>
Nards=c:\Nards\db\NARDS.FDB<br>
Change this to where you have placed your DB.
to the live databases section and good to go.

please note this is a pre-release, i'm actively altering allof of things, database structure is volitile.

i double recommend FlameRobin for administering the firebird db.

~q



