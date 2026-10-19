param(
  [string]$Name = "s",
  [switch]$Analyze
)
# capture + pull + optional analyze
adb -s 192.168.1.5:1031 shell screencap -p /sdcard/$Name.png
adb -s 192.168.1.5:1031 pull /sdcard/$Name.png "$Name.png" | Out-Null
python -c "from PIL import Image; im=Image.open('$Name.png'); im.thumbnail((480,2000)); im.save('${Name}s.png')" 2>$null
if ($Analyze) { python see.py "$Name.png" }
