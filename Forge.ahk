Gui, Add, Button, x640 y30 w100 h30 gupdatewo, Load Wo's
Gui, Add, Button, x640 y70 w100 h30 gupdatehn, Load H#'s
Gui, Add, Button, x640 y110 w100 h30 gprocess, Process
Gui, Add, Button, x640 y150 w100 h30 gexport, Export
Gui, Add, Button, x640 y475 w100 h30 gClear, Clear
Gui, Add, Text, x12 y5 w150 h20 vWoText, Work Orders
Gui, Add, ListBox, x12 y30 w150 h475 vlistboxwo,
Gui, Add, Text, x175 y9 w150 h20 vHNText, Heat Numbers
Gui, Add, ListBox, x175 y30 w150 h475 vlistboxhn,
Gui, Add, Text, x350 y9 w150 h20 vFinalText, Report
Gui, Add, ListBox, x350 y30 w250 h475 vlistboxFinal,
Gui, Show, w750 h530, Forge v1.0
I_Icon = %A_WorkingDir%\Resources\forge.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%
Gui, Add, Progress, x12 Y510 w725 h10 cBlue vMyProgress, 0
IfNotExist, %A_Desktop%\Forge
   FileCreateDir, %A_Desktop%\Forge
return


clear:
MsgBox, 36, Are you sure?, Clicking Yes will completely clear the app of all data.
IfMsgBox Yes
{
    GuiControl,, listboxwo, |
	GuiControl,, listboxhn, |
	GuiControl,, listboxFinal, |
}
	IfMsgBox No
	{
		
	}
return


export:
GuiControl,, MyProgress, 50
FormatTime, oNow, , MM_dd_yy-hh_mm_ss_tt
ControlGet, ItemsFinalList, List,, listbox3, Forge
Loop, Parse, ItemsFinalList, `n
	{	
		StringSplit, ExportReport, A_LoopField, %A_Tab%
		FileAppend, %ExportReport1%`,%ExportReport3%`n, %A_Desktop%\Forge\HNP_%oNow%.csv
	}
												GuiControl,, MyProgress, 100
											sleep, 1000
											GuiControl,, MyProgress, 0
		MsgBox, 36, Open the report?, Would you like to open the report you created?.
				IfMsgBox Yes
					run, %A_Desktop%\Forge\HNP_%oNow%.csv
				IfMsgBox No
					{
						
					}
return



process:
GuiControl,, MyProgress, 50
GuiControl,, listboxFinal, |
ControlGet, Itemswo, List,, listbox1, Forge
ControlGet, Itemshn, List,, listbox2, Forge
Loop, Parse, Itemshn, `n
{
	total_lines=%A_Index%
}


		Loop, Parse, Itemswo, `n
			{
				WoNum= %A_LoopField%
				length:= StrLen(A_LoopField)-4
				StringTrimRight, justNP, A_LoopField, %length%
				Loop, Parse, Itemshn, `n
					{
						IfInString, A_LoopField, %JustNP%
						{
							StringSplit, HNFinalFinal, A_LoopField, %A_tab%,
							StringSplit, WoNumFinalFinal, WoNum, %A_tab%,
							StringReplace, WoNumFin, WoNumFinalFinal2, %A_Tab%, All
							choicesfinal .= WoNumFin A_Tab A_Tab HNFinalFinal2 "|"
							
						}
					}	
			}
		GuiControl,, listboxFinal, %choicesfinal%
		ControlGet, Itemsfinal, List,, listbox3, Forge
			Loop, Parse, Itemsfinal, `n
				{
					finalcounter:= A_index
				}
					GuiControl,, finaltext, % "Report - " finalcounter
											GuiControl,, MyProgress, 100
											sleep, 1000
											GuiControl,, MyProgress, 0					

Return

updatehn:
GuiControl,, listboxHN, |
FileSelectFile, filehn,
if (filehn = "")
	{
		return
	}

	GuiControl,, MyProgress, 50
SplitPath, filehn, name, dir, ext, name_no_ext, drive
	if (ext = "xlsx")
		{
			path = %filehn%
			SplitPath, path, , dir, , noext
			outpath :=  dir . "\" . noext . ".csv"
			xl := ComObjCreate("Excel.Application").Workbooks.Open(path)
			xl.SaveAs(outpath, 6)
			xl.close(0) 
			
				Loop, read, %dir%/%name_no_ext%.csv
					{
						HNtotalLines = %A_index%
					}
InputBox, Userinput, How many lines, There are currently %HNtotalLines% Lines`n`nHow many of the most recent lines would you like to process?,,
			StartLine := HNtotalLines - Userinput
				Loop, read, %dir%/%name_no_ext%.csv
					{
						LineNumber := A_Index
						Loop, parse, A_LoopReadLine, `n`r
								{
									if (LineNumber > StartLine)
									{
										StringTrimLeft, HNTemp, A_LoopReadLine, 1
										StringReplace, HNoutput, HNTemp, `, , %A_Tab%, all
										StringSplit, HNFinal, HNOutput, %A_tab%,
										choiceshn .= HNFinal1 A_tab HNFinal4 "|"
									}
								}
					}
									GuiControl,, listboxhn, %choiceshn%	
									ControlGet, Itemshn, List,, listbox2, Forge
										Loop, Parse, Itemshn, `n
										{
											hncounter:= A_index
										}
											GuiControl,, hntext, % "Heat Numbers - " hncounter
											GuiControl,, MyProgress, 100
											sleep, 1000
											GuiControl,, MyProgress, 0											
		}
	if (ext = "csv")
		{
					Loop, read, %dir%/%name_no_ext%.csv
					{
						HNtotalLines = %A_index%
					}
InputBox, Userinput, How many lines, There are currently %HNtotalLines% Lines`n`nHow many of the most recent lines would you like to process?,,
				Loop, read, %filehn%
					{
						StartLine := HNtotalLines - Userinput
						LineNumber := A_Index
						Loop, parse, A_LoopReadLine, `n`r
								{
									if (LineNumber > StartLine)
									{
										StringTrimLeft, HNTemp, A_LoopReadLine, 1
										StringReplace, HNoutput, HNTemp, `, , %A_Tab%, all
										StringSplit, HNFinal, HNOutput, %A_tab%,
										choiceshn .= HNFinal1 A_tab HNFinal4 "|"
									}
								}
					}
									GuiControl,, listboxhn, %choiceshn%	
									ControlGet, Itemshn, List,, listbox2, Forge
										Loop, Parse, Itemshn, `n
										{
											hncounter:= A_index
										}
											GuiControl,, hntext, % "Heat Numbers - " hncounter	
											GuiControl,, MyProgress, 100
											sleep, 1000
											GuiControl,, MyProgress, 0
		}
return


updatewo:
GuiControl,, listboxWO, |
wocounter=0
FileSelectFile, files, M3 
if (files = "")
	{
		return
	}
GuiControl,, MyProgress, 50
SplitPath, files,, SourceFilePath,, SourceFileNoExt
SplitPath, files, name, dir, ext, name_no_ext, drive
		Loop, parse, files, `n
			{
				if (A_Index = 1)
				path = %A_LoopField%
				else
					{
						Loop, read, %path%\%A_LoopField%
							{
								currentfile = %SourceFilePath%\%A_LoopField%
									Loop, parse, A_LoopReadLine, `n`r
											{
												IfInString, A_LoopReadLine, INFO PartName
													{
														StringTrimLeft, currentfiletrim, currentfile, 13
														StringTrimRight, currentfiletrimfinal, currentfiletrim, 4
														StringTrimLeft, Trimmedrightwo, A_LoopReadLine, 17
														StringReplace, OutputVarwo, Trimmedrightwo, = , %A_Space%, All
														FinalWO# = % SubStr(OutputVarwo, 1, InStr(OutputVarwo, " ") - 1)
														StringReplace, FinalWO#Final, FinalWO#, = , %A_Tab%, All
														StringReplace, FinalWO#Final2, FinalWO#Final, %A_Tab%, , All
														choiceswo .= currentfiletrimfinal A_Tab Trim(FinalWO#Final2) "|"
													}
											}	
							}
							IfMsgBox, No, break
								
					}
	
			}
							GuiControl,, listboxWO, %choiceswo%	
					ControlGet, Itemswo, List,, listbox1, Forge
						Loop, Parse, Itemswo, `n
						{
							wocounter:= A_index
						}
											GuiControl,, wotext, % "Work Orders - " wocounter
											GuiControl,, MyProgress, 100
											sleep, 1000
											GuiControl,, MyProgress, 0
return


GuiClose:
ExitApp