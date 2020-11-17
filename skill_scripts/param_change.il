/* Description   : This code will find an instance CDF parameter
;            for a given instance cellName and change to a new value
;
;   How to Run      : In CIW load the file SITchangeParam.il by providing the path of the .il file:
;            e.g. load("../SITchangeParam.il")
;            SITchangeParam("LibName" "CellName" "schematic" "pe" "m" "2")
;            where testLib   - library name
;              testCell  - cell name
;              schematic - view name
;              cap        - instance cellName
;              model     - parameter name
;              CAP        - new value
*/
procedure( SITchangeParam( libname cellname viewname instCellName paramName newValue)    ;takes the arguments from the function where it is called.
	prog( ()
		cvSchematic = dbOpenCellViewByType(libname cellname "schematic" "" "a")
				;opens the schematic and the object id is stored in cvSchematic(returns object id) 
		foreach(inst cvSchematic~>instances           ;loops through each instance in the schematic view 
			when( inst~>cellName == instCellName   ;compares each instance's cellname with the one passed as argument from the CIW.
				foreach(cdfParam cdfGetInstCDF(inst)~>parameters                            
						;obtains the cdf parameters of the instance(object ids) and loops through each parameter of the selected instance  
					when( cdfParam~>name == paramName        ;compares each cdf parameter's name with the one passed as argument from the CIW.
						cdfParam~>value = newValue       ;the new value of the cdf parameter passed as argument from CIW is assigned.
						);when
					);foreach
				);when
			);foreach
		dbSave(cvSchematic)                             ;save the schematic view.
		dbClose(cvSchematic)                            ;close the schematic view.
		return(t)
  	);prog
);procedure
