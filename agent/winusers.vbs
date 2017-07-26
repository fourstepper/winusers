'----------------------------------------------------------
' Script : Users list
' Version : 2.0
' Date : 23/07/2017
' Author : J.C.BELLAMY � 2000
' OCS adaptation  :	Guillaume PRIOU
' Various updates :	St�phane PAUTREL
'----------------------------------------------------------
On Error Resume Next

Dim Network, Computer, objWMIService
Dim colItems, objItem, colAdmGroup, UserType, UserStatus, objAdm
Dim accent, noaccent, currentChar, result, k, o

Set Network = Wscript.CreateObject("WScript.Network")
Computer=Network.ComputerName

Function StripAccents(str)
	accent   = "��������������������������"
	noaccent = "EEEEUUIIAAOOCeeeeuuiiaaooc"
	currentChar = ""
	result = ""
	k = 0
	o = 0
	For k = 1 To len(str)
		currentChar = mid(str,k, 1)
		o = InStr(accent, currentChar)
		If o > 0 Then
			result = result & mid(noaccent,o,1)
		Else
			result = result & currentChar
		End If
	Next
	StripAccents = result
End Function

Function IfAdmin(str)
	Set colAdmGroup = GetObject("WinNT://./Administrateurs") ' get members of the local admin group
	UserType = "Local user"
	For Each objAdm In colAdmGroup.Members
		If objAdm.Name = objItem.Name Then
			UserType = "Local admin"
		End If
	Next
End Function

Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & computer & "\root\cimv2")

Set colItems = objWMIService.ExecQuery _
	("Select * from Win32_UserAccount Where LocalAccount = True")

For Each objItem in colItems
	IfAdmin(objItem.Name)
	If objItem.Disabled = "False" Or objItem.Disabled = "Faux" Then _
		UserStatus = "Actif" Else UserStatus = "Inactif"
	Wscript.echo _
		"<WINUSERS>" & VbCrLf &_
		"<NAME>" & StripAccents(objItem.Name) & "</NAME>" & VbCrLf &_
		"<TYPE>" & UserType & "</TYPE>" & VbCrLf &_
		"<DESCRIPTION>" & StripAccents(objItem.Description)  & "</DESCRIPTION>" & VbCrLf &_
		"<STATUS>" & UserStatus  & "</STATUS>" & VbCrLf &_
		"<SID>" & objItem.SID  & "</SID>" & VbCrLf &_
		"</WINUSERS>"
Next