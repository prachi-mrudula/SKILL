/* Description: 
         This program generates layout from schematic view for all cells in a library.

   Procedure: 
	Load this file in CIW by giving the file location path: load( "../autogen.il")
	SITautoGenLib("name of the library u want to perform the operation on")
	
*/

/*This is the main function to generate layout from schematic*/
procedure( SITautoGenCell(myLib myCell @optional (view "mylayout"))   ;takes the arguments from the function where it is called.
	prog( ()
		myLpp = list("MET1" "pin")
		myViewList = myCell~>views~>name                      ;returns the list of views names that are present in the selected cell.      
		isSchematic = car( member( "schematic" myViewList))   ;checks whether schematic is present in the views list(returns "schematic" if yes & "nil" if no)
		isLayout = car( member( "mylayout" myViewList))       ;checks whether layout is present in the views list(returns "layout" if yes & "nil" if no)
		if(isSchematic == "schematic"                         ;checks if the selected cell has a schematic, affirming it further takes it into the loop.
			then
				libName = myLib~>name                 ;name of the library
				cellName = myCell~>name               ;name of the cell selected
				cvSchematic = dbOpenCellViewByType(libName cellName "schematic" "" "a") 
							;opens the schematic and the object id is stored in cvSchematic(returns object id) 
				if(isLayout == "mylayout"             ;checks if the selected cell has a layout, affirming it further takes it into the loop.
					then
						layoutId = ddGetObj(libName cellName "mylayout")  ;get the object id of the layout view present in the selected cell.
						ddDeleteObj(layoutId)           ;delete the layout view taking input as object id of the layout view not its name.
						);if
				lxGenFromSource( cvSchematic ?layLibName libName ?layCellName cellName ?layViewName "newlayout")         
							  ;generates the layout view from the schematic view for the selected cell.
				cvLayout = dbOpenCellViewByType(libName cellName "newlayout" "" "a") 
							  ;opens the layout and the object id is stored in cvLayout(returns object id)
				foreach(term cvLayout~>terminals
					term~>pins~>figs~>lpp = myLpp            ;change the pin layer and purpose.
					;add label to pins 
					p1=car(term~>pins)
					f1=car(p1~>figs)
					unless(f1~>children
						disp = dbCreateTextDisplay( term term list("text" "drawing") t centerBox(f1~>bBox) "centerCenter" "R0" "stick" 0.5 nil nil t nil t "name" nil)
						disp~>isNameVisible=nil
						disp~>parent=p1~>fig
						)
					)				
				dbSave(cvLayout)                        ;save the layout view
				dbClose(cvLayout)                       ;close the layout view
				dbClose(cvSchematic)                    ;close the schematic view
				);if
		 if(isSchematic == nil                                  ;when there is no schematic present in the views list of the selected cell.
			then                                                                                                  
				print( "Schematic doesn't exist !")
				);if			
		return(t)
	);prog
);procedure

/*This function is called by the user in the CIW window that takes the library name as argument*/		
procedure( SITautoGenLib(myLib @optional (view "mylayout"))          ;takes the arguments from the CIW window where it is called.
   prog( ()
   	libId = ddGetObj(myLib)                                      ;get Library object id
	foreach(cell libId~>cells                                    ;loop thought each cell in the library one at a time
		myCell = cell~>name                                  ;name of the cell that is selected from  the cells list in library
		SITautoGenCell(libId cell)                           ;calls the function by passing the arguments
		);for
	return(t) 
   );prog
);procedure
