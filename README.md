Simple Powershell wrappers for OpenSSL CA (certification authority)

# New-CA

## SYNOPSIS

Setup a new certification authority

## SYNTAX

```powershell
New-CA [-caPath] <String> [-country] <String> [-state] <String> [-commonName] <String> [-passPhrase] <String> [[-firstSerial] <Int32>] [[-validityDays] <Int32>] [[-privateKeySize] <Int32>] [[-organization] <String>] [[-email] <String>] [[-city] <String>] [[-organizationalUnit] <String>] [-allowDuplicateSubjects] [<CommonParameters>]
```

## DESCRIPTION

The New-CA function initializes a new OpenSSL certification authority
in the given -caPath.

Review the created OpenSSL.cnf file to define behavior and defaults
for your CA.

## PARAMETERS

### -caPath &lt;String&gt;

Full or relative path which will contain OpenSSL configuration file
for a certification authority and related data files.
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -country &lt;String&gt;

Country for the CA, for example US or CZ
```
Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -state &lt;String&gt;

Full name of the state, for example Czech Republic
```
Required?                    true
Position?                    3
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -commonName &lt;String&gt;

Common name of the certification authority for example My Company CA
```
Required?                    true
Position?                    4
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -passPhrase &lt;String&gt;

Password protecting CA private key
```
Required?                    true
Position?                    5
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -firstSerial &lt;Int32&gt;

Initial serial number of the first issued certificate
```
Required?                    false
Position?                    6
Default value                1000
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -validityDays &lt;Int32&gt;

Number of days for which the CA certificate will be valid
```
Required?                    false
Position?                    7
Default value                7300
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -privateKeySize &lt;Int32&gt;

Size of the CA private key in bits
```
Required?                    false
Position?                    8
Default value                4096
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -organization &lt;String&gt;

Name of the CA organization, for example My Company
```
Required?                    false
Position?                    9
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -email &lt;String&gt;

Email for the CA administrator
```
Required?                    false
Position?                    10
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -city &lt;String&gt;

City in which is CA located
```
Required?                    false
Position?                    11
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -organizationalUnit &lt;String&gt;

Organization unit of CA, for example Development
```
Required?                    false
Position?                    12
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -allowDuplicateSubjects &lt;SwitchParameter&gt;

Allows to use the same subject in certificate multiple times
```
Required?                    false
Position?                    named
Default value                False
Accept pipeline input?       false
Accept wildcard characters?  false
```
## INPUTS



## OUTPUTS

### System.Void

## NOTES



## EXAMPLES

### EXAMPLE 1

```powershell
PS >New-CA -caPath c:\MyCA -country CZ -state "Czech Republic" -commonName "My Company CA" -passPhrase MySecret1
```



# New-Certificate

## SYNOPSIS

Creates a new certificate signed by OpenSSL CA

## SYNTAX

```powershell
New-Certificate [-caPath] <String> [-privateKeyName] <String> [-country] <String> [-state] <String> [-commonName] <String> [-passPhrase] <String> [[-type] <String>] [[-privateKeySize] <Int32>] [-pfx] [[-organization] <String>] [[-email] <String>] [[-city] <String>] [[-organizationalUnit] <String>] [<CommonParameters>]
```

## DESCRIPTION

Creates a new certificate signed by a CA previously created using New-CA
function.

## PARAMETERS

### -caPath &lt;String&gt;

Full or relative path which will contain OpenSSL configuration file
for a certification authority and related data files.
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -privateKeyName &lt;String&gt;

File name for the private key. This is not a path, just name.
```
Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -country &lt;String&gt;

Country for the certificate, for example US or CZ
```
Required?                    true
Position?                    3
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -state &lt;String&gt;

Full name of the state, for example Czech Republic
```
Required?                    true
Position?                    4
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -commonName &lt;String&gt;

Common name of the subject. For server this should be server full
domain name
```
Required?                    true
Position?                    5
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -passPhrase &lt;String&gt;

Password for the CA private key
```
Required?                    true
Position?                    6
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -type &lt;String&gt;

Type of the certificate, defines allowed usages for the certificate
```
Required?                    false
Position?                    7
Default value                server
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -privateKeySize &lt;Int32&gt;

Size of the private key in bits
```
Required?                    false
Position?                    8
Default value                2048
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -pfx &lt;SwitchParameter&gt;

Produce also .pfx file containing certificate, private key and
certificate of CA
```
Required?                    false
Position?                    named
Default value                False
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -organization &lt;String&gt;

Name of the organization, for example My Company
```
Required?                    false
Position?                    9
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -email &lt;String&gt;

Email for the certificate owner or administrator in the case
of server certificate
```
Required?                    false
Position?                    10
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -city &lt;String&gt;

City in which is owner of certificate located
```
Required?                    false
Position?                    11
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -organizationalUnit &lt;String&gt;

Organization unit, for example Development
```
Required?                    false
Position?                    12
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```
## INPUTS



## OUTPUTS

### System.Void

## NOTES



## EXAMPLES


# New-Pfx

## SYNOPSIS

Converts the specified certificate and private key to a pfx file

## SYNTAX

```powershell
New-Pfx [-caPath] <String> [-certificatePath] <String> [-privateKeyPath] <String> [-pfxPath] <String> [[-password] <String>] [<CommonParameters>]
```

## DESCRIPTION

Convert key pair specified by -certificatePath and -privateKeyPath to the
output -pfxPath file optionally protected by a password.

Created pfx file contains certificate of CA previously created by New-CA
function.

## PARAMETERS

### -caPath &lt;String&gt;

Full or relative path which will contain OpenSSL configuration file
for a certification authority and related data files.
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -certificatePath &lt;String&gt;

Path to the certificate file
```
Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -privateKeyPath &lt;String&gt;

Path to the private key
```
Required?                    true
Position?                    3
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -pfxPath &lt;String&gt;

Path to the output .pfx file
```
Required?                    true
Position?                    4
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
``` 
### -password &lt;String&gt;

Password which will protected the .pfx file
```
Required?                    false
Position?                    5
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```
## INPUTS



## OUTPUTS

### System.Void

## NOTES



## EXAMPLES


# Get-CertificateDetails

## SYNOPSIS

Gets details about the defined certificate

## SYNTAX

```powershell
Get-CertificateDetails [-path] <String> [<CommonParameters>]
```

## DESCRIPTION



## PARAMETERS

### -path &lt;String&gt;

Full or relative path to a certificate file
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```
## INPUTS



## OUTPUTS

### System.Void

## NOTES



## EXAMPLES

### EXAMPLE 1

```powershell
PS >Get-CertificateDetails -path c:\file.pem
```


