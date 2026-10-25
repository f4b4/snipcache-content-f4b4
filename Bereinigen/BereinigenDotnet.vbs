''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' BereinigenDotNet
' Copyright (c) 2007, Christoph Borchard
' 14.07.2007 17:01

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
verzeichnisse = Array("bin", "obj")

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
	Dim f, fc
	Set f = fso.GetFolder(pfad)
	Set fc = f.SubFolders
	If fc.Count > 0 Then
		For Each f1 In fc
			If Not CleanFolder(f1) Then
				RecurseFolders f1.Path
			End If
		Next
	End If
End Sub

Function CleanFolder(folder)
On Error Resume next
	CleanFolder = False
	For Each verz In verzeichnisse
		If folder.Name = verz Then
			folder.Delete
			CleanFolder = True
			Exit Function
		End If
	Next
End Function

Main
