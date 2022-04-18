$radio = (Get-Process -Name "InstoreRadio" -ErrorAction SilentlyContinue | Select-Object path).path
if ($radio -like "*\InstoreRadio\*"){return "OK"}else{return "OFF"}
