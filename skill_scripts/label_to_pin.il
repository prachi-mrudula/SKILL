/* Description: 
         This program adds labels to pins in layout using SKILL SCRIPTING
*/

cv=geGetWindowCellView()
foreach(term cv~>terminals
	p1=car(term~>pins)       ;the 1st pin's id is stored in list of terminals
	f1=car(p1~>figs)         ;the figure of the pin (eg. - rect) 
	unless(f1~>children      
		disp=dbCreateTextDisplay( term term list("text" "drawing") t centerBox(f1~>bBox) "centerCenter" "R0" "stick" 0.5 nil nil t nil t "name" nil) 
			;pin's label details 
		disp~>isNameVisible=nil ;makes the 'name=' in the text display invisible
		disp~>parent=p1~>fig    ;converts the text such that it moves along with the pin
))
