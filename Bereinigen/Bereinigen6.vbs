''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Bereinigen 5
' Copyright (c) 2003, authors
' 24.06.2003 09:56
' 06.12.2017

' This program is free software;  you can redistribute it and/or modify it
' under the  terms of  the GNU General Public License as  published by the
' Free Software Foundation;  either version 2 of the License,  or (at your
' option) any later version.

' This program is distributed  in the  hope that  it will  be useful,  but
' WITHOUT  ANY  WARRANTY;   without   even   the   implied   warranty   of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
' Public License for more details.

' You should have received a copy of  the GNU General Public License along
' with this program; if not, write to  the Free Software Foundation, Inc.,
' 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' iteriert ausgehend vom aktuellen Verzeichnis durch alle
' Unterverzeichnisse und löscht Dateien mit folgenden Endungen
endungen = Array(".obj", ".pch", ".res", ".idb", ".ilk", ".pdb", _
                 ".sbr", ".bsc", ".exe", ".dll", "_i.h", ".trg", _
                 ".lib", ".exp", ".tlh", ".tli", ".ncb", "_i.c", _
                 "_h.h", ".opt", ".aps", ".clw", ".ocx", _
                 "_p.c", ".plg", ".ipch", ".sdf", ".codeanalysis")

' folgende Dateien werden ebenfalls geloescht                 
dateien = Array("BuildLog.htm", "dlldata.c")

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")

Sub Main
	s = "Alle Unterverzeichnisse bereinigen"
	s = s & vbcrlf & "(auch *.exe)?"
	
	ret = MsgBox(s, vbYesNoCancel + vbDefaultButton3 + vbQuestion, _
	              "Projekte bereinigen")
	If vbYes = ret Then
		CleanFolder "."
		RecurseFolders "."
	End If
	
	Call MsgBox("Fertig", vbOKOnly + vbInformation, _
	             "Projekte bereinigen")
	
End Sub

Sub RecurseFolders(pfad)
On Error Resume next
	Dim f, fc
	Set f = fso.GetFolder(pfad)
	Set fc = f.SubFolders
	If fc.Count > 0 Then
		For Each f1 In fc
			CleanFolder(f1.Path)
			RecurseFolders f1.Path
		Next
	End If
End Sub

Sub CleanFolder(pfad)
On Error Resume next
	Set f = fso.GetFolder(pfad)
	Set fc = f.Files
	For Each f1 In fc
		If IsTempFile (f1.Name) Then
			f1.Delete
		End If
	Next
End Sub

Function IsTempFile (dateiname)
	IsTempFile = False
	
	' endungen ueberpruefen
	For Each s In endungen
		If Right (dateiname, Len(s)) = s Then
			IsTempFile = True
			Exit Function
		End If
	Next
	
	' Dateiname ueberpruefen
	For Each s In dateien
		If dateiname = s Then
			IsTempFile = True
			Exit Function
		End If
	Next
End Function

Main
