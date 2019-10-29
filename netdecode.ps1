################################################################################
#                                                                              #
#  Script for decoding a subnet range with given IP written in CIDR notation   #
#  Known issue when passing /31 or /32, may or may not update in the future    #
#                                                                              #
#                           Joseph McGee 10/29/2019                            #
#                                                                              #
################################################################################



Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$cidraddress
)

# Split CIDR off IP
$ipdec,$smask = $cidraddress.split("/")

# split IP from dotted-decimal 
$odec1,$odec2,$odec3,$odec4 = $ipdec.split(".")

# Select subnet mask in binary
switch ($smask)
{
 0  {$submask = "0.0.0.0"; $wildcard = "255.255.255.255"; break }
 1  {$submask = "128.0.0.0"; $wildcard = "127.255.255.255"; break }
 2  {$submask = "192.0.0.0"; $wildcard = "63.255.255.255"; break }
 3  {$submask = "224.0.0.0"; $wildcard = "31.255.255.255"; break }
 4  {$submask = "240.0.0.0"; $wildcard = "15.255.255.255"; break }
 5  {$submask = "248.0.0.0"; $wildcard = "7.255.255.255"; break }
 6  {$submask = "252.0.0.0"; $wildcard = "3.255.255.255"; break }
 7  {$submask = "254.0.0.0"; $wildcard = "1.255.255.255"; break }
 8  {$submask = "255.0.0.0"; $wildcard = "0.255.255.255"; break }
 9  {$submask = "255.128.0.0"; $wildcard = "0.127.255.255"; break }
 10 {$submask = "255.192.0.0"; $wildcard = "0.63.255.255"; break }
 11 {$submask = "255.224.0.0"; $wildcard = "0.31.255.255"; break }
 12 {$submask = "255.240.0.0"; $wildcard = "0.15.255.255"; break }
 13 {$submask = "255.248.0.0"; $wildcard = "0.7.255.255"; break }
 14 {$submask = "255.252.0.0"; $wildcard = "0.3.255.255"; break }
 15 {$submask = "255.254.0.0"; $wildcard = "0.1.255.255"; break }
 16 {$submask = "255.255.0.0"; $wildcard = "0.0.255.255"; break }
 17 {$submask = "255.255.128.0"; $wildcard = "0.0.127.255"; break }
 18 {$submask = "255.255.192.0"; $wildcard = "0.0.63.255"; break }
 19 {$submask = "255.255.224.0"; $wildcard = "0.0.31.255"; break }
 20 {$submask = "255.255.240.0"; $wildcard = "0.0.15.255"; break }
 21 {$submask = "255.255.248.0"; $wildcard = "0.0.7.255"; break }
 22 {$submask = "255.255.252.0"; $wildcard = "0.0.3.255"; break }
 23 {$submask = "255.255.254.0"; $wildcard = "0.0.1.255"; break }
 24 {$submask = "255.255.255.0"; $wildcard = "0.0.0.255"; break }
 25 {$submask = "255.255.255.128"; $wildcard = "0.0.0.127"; break }
 26 {$submask = "255.255.255.192"; $wildcard = "0.0.0.63"; break }
 27 {$submask = "255.255.255.224"; $wildcard = "0.0.0.31"; break }
 28 {$submask = "255.255.255.240"; $wildcard = "0.0.0.15"; break }
 29 {$submask = "255.255.255.248"; $wildcard = "0.0.0.7"; break }
 30 {$submask = "255.255.255.252"; $wildcard = "0.0.0.3"; break }
 31 {$submask = "255.255.255.254"; $wildcard = "0.0.0.1"; break }
 32 {$submask = "255.255.255.255"; $wildcard = "0.0.0.0"; break }

 default {Write-Host "Please enter CIDR with address"; exit}
}

# Split subnet/wildcard from string
$bdec1,$bdec2,$bdec3,$bdec4 = $submask.split(".")
$wdec1,$wdec2,$wdec3,$wdec4 = $wildcard.split(".")

$wbit = $wdec1,$wdec2,$wdec3,$wdec4 | ForEach-Object {
    [System.Convert]::ToString($_,2).PadLeft(8,'0')
}
$wbit = $wbit -join '.'
$bitmask = $bdec1,$bdec2,$bdec3,$bdec4 | ForEach-Object {
    [System.Convert]::ToString($_,2).PadLeft(8,'0')
}
$bitmask = $bitmask -join '.'

# Find Network IP with submitted IP and subnet mask
$n1 = $odec1 -band $bdec1
$n2 = $odec2 -band $bdec2
$n3 = $odec3 -band $bdec3
$n4 = $odec4 -band $bdec4

# Pass network IP from octets to dotted-decimal string
$netip = $n1.ToString() + "." + $n2.ToString() + "." + $n3.ToString() + "." + $n4.ToString()

# Find broadcast IP
$b1 = $n1 -bxor $wdec1
$b2 = $n2 -bxor $wdec2
$b3 = $n3 -bxor $wdec3
$b4 = $n4 -bxor $wdec4
$bip = $b1,$b2,$b3,$b4 -join '.'

# Find first and last host of network, set octets to string, and join string
$firsthost = $n1.ToString() + "." + $n2.ToString() + "." + $n3.ToString() + "." + ($n4 +=1).ToString()
$lasthost = $b1.ToString() + '.' + $b2.ToString() + '.' + $b3.ToString() + '.' + ($b4 -=1).ToString()

# Output

Write-Host "Input IP:        " $ipdec
Write-Host "Subnet mask:     " $submask `r`n
Write-Host "Network:         " $netip
Write-Host "Broadcast:       " $bip
Write-Host "Host range:      " $firsthost "-" $lasthost
