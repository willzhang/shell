#$language = "VBScript"
#$interface = "1.0"

Sub main
  crt.Screen.Synchronous = True
  crt.Screen.WaitForString "gandalf@TONGYOU04:~>"
  crt.Screen.Send "su - root" & VbCr
  crt.Screen.WaitForString "Password:"
  crt.Screen.Send "Huawei12#$" & VbCr
  crt.Screen.WaitForString "TONGYOU04:~ #"
  crt.Screen.Send "TMOUT=0" & VbCr
  crt.Screen.Synchronous = False
End Sub
