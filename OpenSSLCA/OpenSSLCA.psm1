<#
.SYNOPSIS

Gets location of the openssl.exe

.DESCRIPTION

Gets full path to the openssl.exe which is located in the module folder
#>
function Get-OpenSSL {
    [OutputType([string])]
    Param(

    )
    Process {
        return "$PSScriptRoot\openssl\openssl.exe"
    }
}

<#

.SYNOPSIS

Setup a new certification authority

.DESCRIPTION

The New-CA function initializes a new OpenSSL certification authority
in the given -caPath.

Review the created OpenSSL.cnf file to define behavior and defaults
for your CA.

.PARAMETER caPath

Full or relative path which will contain OpenSSL configuration file
for a certification authority and related data files.

.PARAMETER country

Country for the CA, for example US or CZ

.PARAMETER state

Full name of the state, for example Czech Republic

.PARAMETER commonName

Common name of the certification authority for example My Company CA

.PARAMETER passPhrase

Password protecting CA private key

.PARAMETER firstSerial

Initial serial number of the first issued certificate

.PARAMETER validityDays

Number of days for which the CA certificate will be valid

.PARAMETER privateKeySize

Size of the CA private key in bits

.PARAMETER organization

Name of the CA organization, for example My Company

.PARAMETER email

Email for the CA administrator

.PARAMETER city

City in which is CA located

.PARAMETER organizationalUnit

Organization unit of CA, for example Development

.PARAMETER allowDuplicateSubjects

Allows to use the same subject in certificate multiple times

.EXAMPLE

PS >New-CA -caPath c:\MyCA -country CZ -state "Czech Republic" -commonName "My Company CA" -passPhrase MySecret1
#>
function New-CA {
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory)][string] $caPath,
        [Parameter(Mandatory)][string] $country,
        [Parameter(Mandatory)][string] $state,
        [Parameter(Mandatory)][string] $commonName,
        [Parameter(Mandatory)][string] $passPhrase,
        [Parameter()][int] $firstSerial = 1000,
        [Parameter()][int] $validityDays = 7300,
        [Parameter()][int] $privateKeySize = 4096,
        [Parameter()][string] $organization = $null,
        [Parameter()][string] $email = $null,
        [Parameter()][string] $city = $null,
        [Parameter()][string] $organizationalUnit = $null,
        [Parameter()][switch] $allowDuplicateSubjects
    )
    Process {
        if (Test-Path $caPath) {
            Write-Error "Location $caPath already exist - cannot initialize CA there"
            # TODO: How to handle properly?
            return 
        }

        Write-Verbose "Going to setup new CA in location $caPath"

        New-Folder @( $caPath, "$caPath\certs", "$caPath\crl", "$caPath\newcerts", "$caPath\private", "$caPath\csr")

        New-Item "$caPath\index.txt" -type file
        $firstSerial | Out-File "$caPath\serial" -Encoding ascii -NoClobber
        
        if ($allowDuplicateSubjects) {
            Write-Verbose "Allowing duplicate subjects"

            "unique_subject = no" | Out-File "$caPath\index.txt.attr" -Encoding ascii
        }

        $unixPath = Get-UnixPath $caPath

        (Get-Content "$PSScriptRoot\openssl\openssl.cnf").Replace('${dir_token}', $unixPath) | Out-File "$caPath\openssl.cnf" -Encoding ascii -NoClobber

        $cfg = Get-CAConfig $caPath
        
        &(Get-OpenSSL) genrsa -aes256 -passout pass:$passPhrase -out "$unixPath/private/ca.key.pem" $privateKeySize

        $subj = "/C=$country/ST=$state/O=$organization/emailAddress=$email/OU=$organizationalUnit/CN=$commonName"

        &(Get-OpenSSL) req  -config $cfg  `
                            -key "$unixPath/private/ca.key.pem" `
                            -new -x509 -days $validityDays -sha256 -extensions v3_ca `
                            -out "$unixPath/certs/ca.cert.pem" -passin pass:$passPhrase -subj $subj
        
        Write-Verbose "Review file $cfg to setup your CA"
    }
}

<#

.SYNOPSIS

Gets details about the defined certificate

.PARAMETER path

Full or relative path to a certificate file

.EXAMPLE

PS >Get-CertificateDetails -path c:\file.pem
#>
function Get-CertificateDetails {
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory)][string] $path
    )
    Process {
        &(Get-OpenSSL) x509 -noout -text -in $path
    }
}

<#

.SYNOPSIS

Converts the specified certificate and private key to a pfx file

.DESCRIPTION

Convert key pair specified by -certificatePath and -privateKeyPath to the
output -pfxPath file optionally protected by a password.

Created pfx file contains certificate of CA previously created by New-CA
function.

.PARAMETER caPath

Full or relative path which will contain OpenSSL configuration file
for a certification authority and related data files.

.PARAMETER certificatePath

Path to the certificate file

.PARAMETER privateKeyPath

Path to the private key

.PARAMETER pfxPath

Path to the output .pfx file

.PARAMETER password

Password which will protected the .pfx file
#>
function New-Pfx {
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory)][string] $caPath,
        [Parameter(Mandatory)][string] $certificatePath,
        [Parameter(Mandatory)][string] $privateKeyPath,
        [Parameter(Mandatory)][string] $pfxPath,
        [Parameter()][string] $password
    )
    Process {
        $unixPath = Get-UnixPath $caPath

        &(Get-OpenSSL) pkcs12 -export -passout pass:"$password" -out $pfxPath -inkey $privateKeyPath -in $certificatePath -certfile "$unixPath/certs/ca.cert.pem"
        
        Write-Verbose "PFX file created $pfxPath"
    }
}

<#

.SYNOPSIS

Creates a new certificate signed by OpenSSL CA

.DESCRIPTION

Creates a new certificate signed by a CA previously created using New-CA
function.

.PARAMETER caPath

Full or relative path which will contain OpenSSL configuration file
for a certification authority and related data files.

.PARAMETER privateKeyName

File name for the private key. This is not a path, just name.

.PARAMETER country

Country for the certificate, for example US or CZ

.PARAMETER state

Full name of the state, for example Czech Republic

.PARAMETER commonName

Common name of the subject. For server this should be server full
domain name

.PARAMETER passPhrase

Password for the CA private key

.PARAMETER type

Type of the certificate, defines allowed usages for the certificate

.PARAMETER privateKeySize

Size of the private key in bits

.PARAMETER pfx

Produce also .pfx file containing certificate, private key and
certificate of CA

.PARAMETER organization

Name of the organization, for example My Company

.PARAMETER email

Email for the certificate owner or administrator in the case
of server certificate

.PARAMETER city

City in which is owner of certificate located

.PARAMETER organizationalUnit

Organization unit, for example Development

#>
function New-Certificate {
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory)][string] $caPath,
        [Parameter(Mandatory)][string] $privateKeyName,
        [Parameter(Mandatory)][string] $country,
        [Parameter(Mandatory)][string] $state,
        [Parameter(Mandatory)][string] $commonName,
        [Parameter(Mandatory)][string] $passPhrase,
        [Parameter()][ValidateSet('usr', 'server')][string] $type = "server",
        [Parameter()][int] $privateKeySize = 2048,
        [Parameter()][switch] $pfx,
        [Parameter()][string] $organization = $null,
        [Parameter()][string] $email = $null,
        [Parameter()][string] $city = $null,
        [Parameter()][string] $organizationalUnit = $null
    )
    Process {
        Write-Verbose "Generating private key of size $privateKeySize"

        $privateKeyFile = "$privateKeyName.pem"
        
        &(Get-OpenSSL) genrsa -out $privateKeyFile $privateKeySize

        $now = Get-Date -Format -- FileDateTimeUniversal

        $cfg = Get-CAConfig $caPath
        
        $unixPath = Get-UnixPath $caPath
        
        $requestFile = "$unixPath/csr/$now-$privateKeyName.csr.pem"
        $certFileCA = "$unixPath/certs/$now-$privateKeyName.cert.pem"

        Write-Verbose "Creating certificate request $requestFile"
        
        $subj = "/C=$country/ST=$state/O=$organization/emailAddress=$email/OU=$organizationalUnit/CN=$commonName"

        &(Get-OpenSSL) req -config $cfg `
            -key $privateKeyFile `
            -new -sha256 -out $requestFile -subj $subj

        Write-Verbose "Signing request $subj"

        &(Get-OpenSSL) ca -config $cfg `
            -extensions "${type}_cert" -days 375 -md sha256 `
            -in $requestFile `
            -out $certFileCA -passin pass:$passPhrase

        $certFile = "$privateKeyName.cert.pem"

        Copy-Item $certFileCA $certFile

        Write-Verbose "Private key $privateKeyFile, certificate $certFile"

        if ($pfx) {
            New-Pfx -caPath $caPath -certificatePath "$privateKeyName.cert.pem" -privateKeyPath "$privateKeyName.pem" -pfxPath "$privateKeyName.pfx" -noPassword
        }
    }
}

function New-Folder {
    Param(
        [Parameter(Mandatory)][string[]] $folders
    )
    Process {
        foreach($folder in $folders) {
            Write-Verbose "Going to create $folder"

            New-Item -type directory $folder
        }
    }
}

function Get-UnixPath {
    [OutputType([string])]
    Param(
        [Parameter(Mandatory)][string] $path
    )
    Process {
        return $path.Replace('\', '/')
    }
}

function Get-CAConfig {
    [OutputType([string])]
    Param(
        [Parameter(Mandatory)][string] $caPath
    )
    Process {
        $unixPath = Get-UnixPath $caPath

        return "$unixPath/openssl.cnf"
    }
}
