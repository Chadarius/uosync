Set WshShell = CreateObject("Wscript.Shell")

strPath = Wscript.ScriptFullName
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(strPath)
strFolder = objFSO.GetParentFolderName(objFile) 

WshShell.Run chr(34) & strFolder & "\startuor.cmd" & Chr(34), 0
Set Wshell = Nothing
