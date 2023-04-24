# ECEN-403---Team-39
The database management system handles all of the inventory data for the application. This subsystem parses through, creates, and deletes information stored in both the user and inventory database when given commands from the UI or the ML model. These commands are defined in the database functions.


The database functions subsystem will act as a library of defined functions used to navigate and manipulate both the user and inventory databases. This set of functions will be the way that the databases interact with the ML model and the UI. The UI will call database functions with specific parameters dependent on the user and what they have selected in the UI. These functions will parse through both databases and return any relevant information as well as changing some of the data entries if the function called requires such.
The database functions as the interaction point between the inventory database and the ML model. When the ML model identifies an inventory item it will call a database function with the item ID as the parameter. The database function will then find all of the information relevant to that item and send it to the UI to be displayed


This database will contain all the information relevant to a registered user account. This database will only ever interact directly with the database functions which act as a bridge between the database and the rest of the application. Indirectly this database interacts much with the UI, one main interaction is the database stores the information on which UI to display.


Like the user database, the inventory database will only interact directly with the database functions. Unlike the user database the inventory database interacts indirectly with both the UI and the ML model. The ML model calls an inventory database function when it identifies an object.
