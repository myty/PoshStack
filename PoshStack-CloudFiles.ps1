<############################################################################################

PoshStack
                                                    Cloud Files

    
Description
-----------
**TODO**

############################################################################################>

#CopyStream

#BulkDelete **TODO**
function Remove-CloudFilesObjects{
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string] $ContainerName= $(throw "Please specify required Container Name with the -ContainerName paramter"),
        [Parameter (Mandatory=$True)] [array]  $ItemsToDelete = $(throw "Please specify required items to be deleted with the -ItemsToDelete parameter"),
        [Parameter (Mandatory=$False)][hashtable]  $Headers = $Null,
        [Parameter (Mandatory=$False)][bool]   $UseInternalUrl = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride = $Null
    )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Remove-CloudFilesObjects"
        Write-Debug -Message "Account.......: $Account" 
        Write-Debug -Message "Container.....: $ContainerName"
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "Headers.......: $Headers"
        Write-Debug -Message "ItemsToDelete.: $ItemsToDelete" 
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 

        # ItemsToDelete is a hashtable, with the Key being the Container Name, and the Value being an array of Object Names
        # e.g. @{"Container1" = @("Object1", "Object2", "Object4"); "Container2" = @("Object1", "ObjectX")}
        # In this example, three objects are deleted from container "Container1", and two objects are deleted from container "Container2"

        Write-Host "Create IEnumerable array"
        
        $ItemsArray = New-Object 'System.Collections.Generic.List[hashtable]'
        $hdr = New-Object 'System.Collections.Generic.Dictionary[String,String]'
        
        Write-Host "ItemsArray is type:"
        Write-Host $ItemsArray.GetType()

        
        
        Write-Host "Add items to array"

        foreach($Item in $ItemsToDelete){
            $ContainerName
            $Item
            $ThisItem = New-Object 'System.Collections.Generic.Dictionary[String,String]'

            #$ThisItem += $ContainerName
            #$ThisItem += $Item
            Write-Host "Add container name to ThisItem"
            Write-Host $ThisItem.GetType()
            #$ThisArray.Add($ThisItem)
            #$ItemsArray.Add($ThisItem)
            Write-Host "Adding ThisItem to ItemsArray"
            #$ItemsArray.add($ContainerName, $Item)
            #$ItemsArray.Add($ThisItem)
            $ThisItem.Add($ContainerName, $Item)
            #$ThisArray += $ThisItem
            Write-Host "Added ThisItem to ItemsArray"
            $ItemsArray.Add($ThisItem)
        }
        Write-Host "Itemsarray:"
        #$ItemsArray
        Write-Host $ItemsArray.Count
        Write-Host "ItemsArray is type:"
        Write-Host $ItemsArray.GetType()
        Write-Host "Headers is type:"
        Write-Host $Headers.GetType()
        Write-Host "Region is type:"
        Write-Host $Region.GetType()
        Write-Host "UseInternalUrl is type:"
        Write-Host $UseInternalUrl.GetType()
        Write-Host "Region $Region"
        Write-Host $cloudId

        Write-Host "CALL THE METHOD!"
        #$cloudFilesProvider.BulkDelete($ItemsArray, $Headers, $Region, $UseInternalUrl, $cloudId)

        $Foo = New-Object 'System.Collections.Generic.Dictionary[String,String]'
        #$Foo.Add("Container1","book.docx")
        $Foo.Add("Container1","amen_main.html")
        $cloudFilesProvider.BulkDelete($Foo, $hdr, $Region, $UseInternalUrl, $cloudId)
        #$cloudFilesProvider.BulkDelete($ItemsArray, $hdr, $Region, $UseInternalUrl, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Bulk delete of objects in containers.

 .DESCRIPTION
 The Remove-CloudFilesObjects cmdlet allows you to bulk delete multiple objects in multiple containers.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER Headers
 The metadata for this container:
 X-Container-Meta-name (Optional)
 Custom container metadata. Replace name at the end of the header with the name for your metadata.

 X-Container-Read (Optional)
 Sets an access control list (ACL) that grants read access. This header can contain a comma-delimited list of users that can read the container (allows the GET method for all objects in the container).

 X-Container-Write (Optional)
 Sets an ACL that grants write access. This header can contain a comma-delimited list of users that can write to the container (allows PUT, POST, COPY, and DELETE methods for all objects in the container).

 X-Versions-Location (Optional)
 Enables versioning on this container. The value is the name of another container. You must UTF-8-encode and then URL-encode the name before you include it in the header. To disable versioning, set the header to an empty string.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> New-CloudFileContainer -Account demo -ContainerName "MyTestContainer"
 This example will create the container "MyTestContainer" in the default region for the account "demo".

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createcontainer_v1__account___container__containerServicesOperations_d1e000.html
#>
}

#CopyObject **TODO**
function Copy-CloudFilesobject{
}

#CreateContainer
function New-CloudFilesContainer{
    Param(
        [Parameter (Mandatory=$True)] [string]    $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string]    $ContainerName = $(throw "Please specify required Container Name with -ContainerName parameter"),
        [Parameter (Mandatory=$False)][hashtable] $Headers,
        [Parameter (Mandatory=$False)][bool]      $UseInternalUrl,
        [Parameter (Mandatory=$False)][string]    $RegionOverride
        )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "New-CloudFilesContainer"
        Write-Debug -Message "Account.......: $Account" 
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "ContainerName.: $ContainerName" 
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 


        return $cloudFilesProvider.CreateContainer($ContainerName, $Headers, $Region, $UseInternalUrl, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Create a Cloud Files Container.

 .DESCRIPTION
 The New-CloudFilesContainer cmdlet creates a Cloud Files container. Containers are storage compartments for your data. The URL-encoded name must be no more than 256 bytes and cannot contain a forward slash character (/). You can create up to 500,000 containers in your Cloud Files account.

 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER Headers
 The metadata for this container:
 X-Container-Meta-name (Optional)
 Custom container metadata. Replace name at the end of the header with the name for your metadata.

 X-Container-Read (Optional)
 Sets an access control list (ACL) that grants read access. This header can contain a comma-delimited list of users that can read the container (allows the GET method for all objects in the container).

 X-Container-Write (Optional)
 Sets an ACL that grants write access. This header can contain a comma-delimited list of users that can write to the container (allows PUT, POST, COPY, and DELETE methods for all objects in the container).

 X-Versions-Location (Optional)
 Enables versioning on this container. The value is the name of another container. You must UTF-8-encode and then URL-encode the name before you include it in the header. To disable versioning, set the header to an empty string.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> New-CloudFileContainer -Account demo -ContainerName "MyTestContainer"
 This example will create the container "MyTestContainer" in the default region for the account "demo".

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createcontainer_v1__account___container__containerServicesOperations_d1e000.html
#>
}

#CreateFormPostUri

#CreateObject **TODO**
function Add-CloudFilesObject{
}

#CreateObjectFromFile **TODO**
function Add-CloudFilesObjectFromFile{
    Param(
        [Parameter (Mandatory=$True)] [string]    $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string]    $ContainerName = $(throw "Please specify required Container Name with -ContainerName parameter"),
        [Parameter (Mandatory=$True)] [string]    $FilePath = $("Please specify required File Path with the -FilePath parameter"),
        [Parameter (Mandatory=$False)][string]    $ObjectName,
        [Parameter (Mandatory=$False)][string]    $ContentType,
        [Parameter (Mandatory=$False)][int]       $ChunkSize = 4096,
        [Parameter (Mandatory=$False)][hashtable] $Headers = $Null,
        [Parameter (Mandatory=$False)][bool]      $UseInternalUrl = $False,
        [Parameter (Mandatory=$False)][string]    $RegionOverride
        )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Add-CloudFilesObjectFromFile"
        Write-Debug -Message "Account.......: $Account" 
        Write-Debug -Message "cloudId.......: $cloudId"
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "ContainerName.: $ContainerName" 
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 
        Write-Debug -Message "FilePath......: $FilePath"
        Write-Debug -Message "ObjectName....: $ObjectName"
        Write-Debug -Message "ContentType...: $ContentType"
        Write-Debug -Message "ChunkSize.....: $ChunkSize"
        Write-Debug -Message "Headers.......: $Headers"

        
        $cloudFilesProvider.CreateObjectFromFile($ContainerName, $FilePath, $ObjectName, $ContentType, $ChunkSize, $Headers, $Region, $null, $UseInternalUrl, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }

<#
 .SYNOPSIS
 Creates or updates the content and metadata for a specified object.

 .DESCRIPTION
 The Add-CloudFilesObjectFromFile cmdlet creates a Cloud Files object by reading and uploading the object from the given file path.

 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER FilePath
 The source file path, e.g. "C:\temp\foo.jpg".

 .PARAMETER ObjectName
 The name assigned to the object in the container. If omitted, the file name (from -FilePath) will be used.

 .PARAMETER ContentType
 The content type. If omitted, it will be automatically determined by the file name.

 .PARAMETER ChunkSize
 The buffer size to use for copying streaming data.

 .PARAMETER Headers
 The metadata information for the object.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> Add-CloudFilesObjectFromFile -Account demo -ContainerName "MyTestContainer" -FilePath "C:\test\helloworld.jpg" -ObjectName "Hello_World.jpg"
 This example will copy the local file "C:\test\helloworld.jpg" to the container "MyTestContainer", in the default region, and rename it to "Hello_World.jpg".

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createobject_v1__account___container___object__objectServicesOperations_d1e000.html
#>
}

#CreateTemporaryPublicUri

#DeleteContainer **TODO**
function Remove-CloudFilesContainer{
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string] $ContainerName = $(throw "Please specify required Container Name with -ContainerName parameter"),
        [Parameter (Mandatory=$False)][bool]   $DeleteObjects = $False,
        [Parameter (Mandatory=$False)][bool]   $UseInternalUrl = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
        )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Remove-CloudFilesContainer"
        Write-Debug -Message "Account.......: $Account" 
        Write-Debug -Message "cloudId.......: $cloudId"
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "ContainerName.: $ContainerName" 
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 
        Write-Debug -Message "DeleteObjects.: $DeleteObjects"

        
        $cloudFilesProvider.DeleteContainer($ContainerName, $DeleteObjects, $Region, $UseInternalUrl, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }

<#
 .SYNOPSIS
 Deletes a Container.

 .DESCRIPTION
 The Remove-CloudFilesContainer cmdlet deletes a Cloud Files container. If a Container is not empty, you must use the -DeleteObjects parameter to delete the contents and the Container; otherwise, the Container will not be deleted if it contains objects.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER DeleteObjects
 This parameter allows you to delete a Container that contains objects. If this is not set to $TRUE, and if the Container contains objects, the Container will not be deleted.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> Remove-CloudFileContainer -Account demo -ContainerName "MyTestContainer"
 This example will delete the container "MyTestContainer" in the default region for the account "demo" only if the container is empty.

 PS C:\Users\Administrator> Remove-CloudFileContainer -Account demo -ContainerName "MyTestContainer" -DeleteObjects $True
 This example will delete the container "MyTestContainer" in the default region for the account "demo"; all of the objects in the container will be deleted.

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/DELETE_deletecontainer_v1__account___container__containerServicesOperations_d1e000.html
#>
}

#DeleteContainerMetadata **TODO**
function Remove-CloudFilesContainerMetadata{
}

#DeleteObject **TODO**
function Remove-CloudFilesObject{
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string] $ContainerName= $(throw "Please specify required Container Name with the -ContainerName paramter"),
        [Parameter (Mandatory=$True)] [string] $ObjectName = $(throw "Please specify required object to be deleted with the -ObjectName parameter"),
        [Parameter (Mandatory=$False)][array]  $Headers = $Null,
        [Parameter (Mandatory=$False)][bool]   $DeleteSegments = $True,
        [Parameter (Mandatory=$False)][bool]   $UseInternalUrl = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride = $Null
    )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Remove-CloudFilesObject"
        Write-Debug -Message "Account.......: $Account" 
        Write-Debug -Message "Container.....: $ContainerName"
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "Headers.......: $Headers"
        Write-Debug -Message "ObjectName....: $ObjectName" 
        Write-Debug -Message "DeleteSegments: $DeleteSegments"
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 

        $cloudFilesProvider.DeleteObject($ContainerName, $ObjectName, $Headers, $DeleteSegments, $Region, $UseInternalUrl, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Delete an object in containers.

 .DESCRIPTION
 The Remove-CloudFilesObject cmdlet performs a DELETE operation on an object to permanently remove the object from the storage system (data and metadata).
 Object deletion is processed immediately at the time of the request. Any subsequent GET, HEAD, POST, or DELETE operations return a 404 (Not Found) error unless object versioning is on and other versions exist.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER ObjectName
 The unique (within the container) identifier of the object.

 .PARAMETER Headers
 The metadata for the object.

 .PARAMETER DeleteSegments
 Indicates whether the file's segments should be deleted if any exist.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> Remove-CloudFilesObject -Account demo -ContainerName "MyTestContainer" -ObjectName "Foo"
 This example will delete the object "Foo" in container "MyTestContainer" in the default region for the account "demo".

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/DELETE_deleteobject_v1__account___container___object__objectServicesOperations_d1e000.html
#>
}

#DeleteObjectMetadata **TODO**
function Remove-CloudFilesObjectMetadata{
}

#DisableCDNOnContainer **TODO**
function Disable-CloudFilesContainerCDN{
}

#DisableStaticWebOnContainer **TODO**
function Disable-CloudFilesStaticWebOnContainer{
}

#EnableCDNOnContainer **TODO**
function Enable-CloudFilesContainerCDN{
    Param(
        [Parameter (Mandatory=$True)] [string]    $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string]    $ContainerName = $(throw "Please specify required Container Name with -ContainerName parameter"),
        [Parameter (Mandatory=$True)] [bool]      $LogRetention = $(throw "Please specify required Log Retention value with the -LogRetention parameter"),
        [Parameter (Mandatory=$False)][string]    $RegionOverride
        )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Enable-CloudFilesContainerCDN"
        Write-Debug -Message "Account.......: $Account" 
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "ContainerName.: $ContainerName" 
        Write-Debug -Message "LogRetention..: $LogRetention" 


        return $cloudFilesProvider.EnableCDNOnContainer($ContainerName, $LogRetention, $Region, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Enables a container for use with the CDN.

 .DESCRIPTION
 The Enable-CloudFileContainerCDN cmdlet enables a Cloud Files container for use with the CDN. It returns four URIs:
 X-Cdn-Ssl-Uri:       The URI for downloading the object over HTTPS, using SSL.
 X-Cdn-Ios-Uri:       The URI for video streaming that uses HTTP Live Streaming from Apple.
 X-Cdn-Uri:           Indicates the URI that you can combine with object names to serve objects through the CDN.
 X-Cdn-Streaming-Uri: The URI for video streaming that uses HTTP Dynamic Streaming from Adobe.

 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER LogRetention
 To enable log retention on the container.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> Enable-CloudFilesContainerCDN -Account demo -ContainerName "Container1" -RegionOverride "ORD" -LogRetention $false
 This example will enable the container "Container1" in region "ORD" for the CDN. Logs will not be retained.
 Key   : X-Cdn-Ssl-Uri
 Value : https://028bafb1829649a871c1-6a72eeb73f78514eb83f17de21d72eb7.ssl.cf2.rackcdn.com
 
 Key   : X-Cdn-Ios-Uri
 Value : http://f0aafc8ff1453a3dda4f-6a72eeb73f78514eb83f17de21d72eb7.iosr.cf2.rackcdn.com
 
 Key   : X-Cdn-Uri
 Value : http://f1e2a7f36b07f7d67f47-6a72eeb73f78514eb83f17de21d72eb7.r7.cf2.rackcdn.com
 
 Key   : X-Cdn-Streaming-Uri
 Value : http://e593f92048ccc6711871-6a72eeb73f78514eb83f17de21d72eb7.r7.stream.cf2.rackcdn.com
 
 Key   : X-Trans-Id
 Value : tx77dbefc6b52a4411a98d0-0054a6d053ord1
 
 Key   : Content-Length
 Value : 0

 Key   : Content-Type
 Value : text/html; charset=UTF-8
 
 Key   : Date
 Value : Fri, 02 Jan 2015 17:07:31 GMT

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_enableDisableCDNcontainer_v1__account___container__CDN_Container_Services-d1e2632.html
#>
}

#EnableStaticWebOnContainer **TODO**
function Enable-CloudFilesStaticWebOnContainer{
}

#ExtractArchive
#ExtractArchiveFromFile
#GetAccountHeaders
#GetAccountMetaData

#GetContainerCDNHeader **TODO*
function Get-CloudFilesContainerCDNHeader{
}

#GetContainerHeader **TODO**
function Get-CloudFilesHeader{
}

#GetContainerMetaData **TODO**
function Get-CloudFilesContainerMetadata{
}

#GetObject **TODO**
function Get-CloudFilesObject{
}

#GetObjectHeaders **TODO**
function Get-CloudFilesObjectHeaders{
}

#GetObjectMetaData **TODO**
function Get-CloudFilesObjectMetadata{
}

#GetObjectSaveToFile **TODO**
function Copy-CloudFilesObjectToFile{
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string] $ContainerName = $(throw "Please specify required Container Name with the -ContainerName parameter"),
        [Parameter (Mandatory=$True)] [string] $SaveDirectory = $(Throw "Please specify the target file path with the -SaveDirectory parameter"),
        [Parameter (Mandatory=$True)] [string] $ObjectName = $(Throw "Please specify the object name with the -ObjectName parameter"),
        [Parameter (Mandatory=$False)][string] $FileName = $Null,
        [Parameter (Mandatory=$False)][int]    $ChunkSize = 65536,
        [Parameter (Mandatory=$False)][Array]  $Headers = $Null,
        [Parameter (Mandatory=$False)][string] $RegionOverride = $Null,
        [Parameter (Mandatory=$False)][bool]   $VerifyETag = $False,
        [Parameter (Mandatory=$False)][long]   $ProgressUpdated = $Null,
        [Parameter (Mandatory=$False)][bool]   $UseInternalUrl = $False
    )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Copy-CloudFilesObjectToFile"
        Write-Debug -Message "Account........: $Account" 
        Write-Debug -Message "ContainerName..: $ContainerName"
        Write-Debug -Message "RegionOverride.: $RegionOverride" 
        Write-Debug -Message "SaveDirectory..: $SaveDirectory"
        Write-Debug -Message "ObjectName.....: $ObjectName"
        Write-Debug -Message "FileName.......: $FileName" 
        Write-Debug -Message "ChunkSize......: $ChunkSize" 
        Write-Debug -Message "Headers........: $Headers" 
        Write-Debug -Message "VerifyETag.....: $VerifyETag" 
        Write-Debug -Message "ProgressUpdated: $ProgressUpdated" 
        Write-Debug -Message "UseInternalUrl.: $UseInternalUrl" 

        $cloudFilesProvider.GetObjectSaveToFile($ContainerName, $SaveDirectory, $ObjectName, $FileName, $ChunkSize, $Headers, $Region, $VerifyETag, $ProgressUpdated, $UseInternalUrl, $cloudId)
        #$cloudFilesProvider.GetObjectSaveToFile("Container1", "C:\Temp", "iChats", $Null, 65536, $Null, "ORD", $Null, $null, $null, $cloudId)

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Gets an object, saving the data to the specified file.

 .DESCRIPTION
 The Copy-CloudFilesObjectToFile cmdlet will get an object from a container and save it to the local file system.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER ContainerName
 The unique identifier of the container.

 .PARAMETER SaveDirectory
 The local file system path to which to save the object.

 .PARAMETER ObjectName
 The name of the object to be retrieved.

 .PARAMETER FileName
 The name to give the object on the local file system. If omitted, the object name is used.

 .PARAMETER ChunkSize
 The buffer size to use for copying streaming data.

 .PARAMETER Headers
 A collection of custom HTTP headers to include with the request.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .PARAMETER VerifyETag
 If the object includes an ETag, the retrieved data will be verified before returning.

 .PARAMETER ProgressUpdated
 A callback for progress updates. If the value is null, no updates are reported.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .EXAMPLE
 PS C:\Users\Administrator> Copy-CloudFilesObjectToFile -Account demo -ContainerName "Container1" -SaveDirectory "C:\temp" -ObjectName "kittens.jpg"
 This example will get the object "kittens.jpg" from the container "Container1" and save it as "C:\temp\kittens.jpg".

 .EXAMPLE
 PS C:\Users\Administrator> Copy-CloudFilesObjectToFile -Account demo -ContainerName "Container1" -SaveDirectory "C:\temp" -ObjectName "kittens.jpg" -FileName "kittycat.jpg"
 This example will get the object "kittens.jpg" from the container "Container1" and save it as "C:\temp\kittycat.jpg".


 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createcontainer_v1__account___container__containerServicesOperations_d1e000.html
#>
}

#ListCDNContainers **TODO** (use -CDN switch)
#ListContainers **TODO**
function Get-CloudFilesContainers{
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$False)][int]    $Limit = 10000,
        [Parameter (Mandatory=$False)][string] $Marker = $null,
        [Parameter (Mandatory=$False)][string] $MarkerEnd = $Null,
        [Parameter (Mandatory=$False)][bool]   $UseInternalUrl = $False,
        [Parameter (Mandatory=$False)][switch] $CDN,
        [Parameter (Mandatory=$False)][string] $RegionOverride = $Null
    )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Get-CloudFilesContainers"
        Write-Debug -Message "Limit.........: $Limit"
        Write-Debug -Message "Marker........: $Marker"
        Write-Debug -Message "MarkerEnd.....: $MarkerEnd"
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 
        
        If ($CDN) {
            Return $cloudFilesProvider.ListCDNContainers($Limit, $Marker, $MarkerEnd, $True, $Region, $cloudId)
        } else {
            Return $cloudFilesProvider.ListContainers($Limit, $Marker, $MarkerEnd, $Region, $UseInternalUrl, $cloudId)
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get the containers in a region.

 .DESCRIPTION
 The Get-CloudFilesContainers cmdlet lists the storage containers in your account and sorts them by name. The list is limited to 10,000 containers at a time.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER Limit
 This parameter allows you to limit the number of results.

 .PARAMETER Marker
 This parameter allows you to begin the list at a specific container name.

 .PARAMETER MarkerEnd
 This parameter allows you to end the list at a specific container name.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER CDN
 This parameter will return CDN-related information for each container.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> Get-CloudFilesContainers -Account demo
 This example will get the containers in the default region for the account "demo".

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/GET_listcontainers_v1__account__accountServicesOperations_d1e000.html
#>
}

#ListObjects **TODO**
function Get-CloudFilesObjects{
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter (Mandatory=$True)] [string] $Container = $(throw "Please specify required Container with the -Container parameter"),
        [Parameter (Mandatory=$False)][int]    $Limit = 10000,
        [Parameter (Mandatory=$False)][string] $Marker = $null,
        [Parameter (Mandatory=$False)][string] $MarkerEnd = $Null,
        [Parameter (Mandatory=$False)][string] $Prefix = $Null,
        [Parameter (Mandatory=$False)][bool]   $UseInternalUrl = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride = $Null
    )

    Get-CloudAccount($Account)

    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    try {

        # Get Identity Provider
        $cloudId = Get-CloudIdentityProvider -Username $Credentials.CloudUsername -APIKey $Credentials.CloudAPIKey

        # Get Cloud Servers Provider
        $cloudFilesProvider = New-Object net.openstack.Providers.Rackspace.CloudFilesProvider

        # Use Region code associated with Account, or was an override provided?
        if ($RegionOverride) {
            $Region = $Global:RegionOverride
        } else {
            $Region = $Credentials.Region
        }

        # DEBUGGING       
        Write-Debug -Message "Get-CloudFilesObjects"
        Write-Debug -Message "Container.....: $Container"
        Write-Debug -Message "Limit.........: $Limit"
        Write-Debug -Message "Marker........: $Marker"
        Write-Debug -Message "MarkerEnd.....: $MarkerEnd"
        Write-Debug -Message "Prefix........: $Prefix"
        Write-Debug -Message "RegionOverride: $RegionOverride" 
        Write-Debug -Message "UseInternalUrl: $UseInternalUrl" 
        
        $ListOfObjects = $cloudFilesProvider.ListObjects($Container, $Limit, $Marker, $MarkerEnd, $Prefix, $Region, $UseInternalUrl, $cloudId)
        foreach ($cloudObject in $ListOfObjects) {
            Add-Member -InputObject $cloudObject -MemberType NoteProperty -Name Region -Value $Region
            Add-Member -InputObject $cloudObject -MemberType NoteProperty -Name Container -Value $Container
        }

        Return $ListOfObjects

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get the containers in a region.

 .DESCRIPTION
 The Get-CloudFilesContainers cmdlet lists the storage containers in your account and sorts them by name. The list is limited to 10,000 containers at a time.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshStack configuration file.

 .PARAMETER Limit
 This parameter allows you to limit the number of results.

 .PARAMETER Marker
 This parameter allows you to begin the list at a specific container name.

 .PARAMETER MarkerEnd
 This parameter allows you to end the list at a specific container name.

 .PARAMETER UseInternalUrl
 Use the endpoint internal URL instead of the endpoint Public URL. 

 .PARAMETER CDN
 This parameter will return CDN-related information for each container.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshStack configuration file. 

 .EXAMPLE
 PS C:\Users\Administrator> Get-CloudFilesContainers -Account demo
 This example will get the containers in the default region for the account "demo".

 .LINK
 http://docs.rackspace.com/files/api/v1/cf-devguide/content/GET_listcontainers_v1__account__accountServicesOperations_d1e000.html
#>
}

#MoveObject **TODO**
function Move-CloudFilesObject{
}

#PurgeObjectFromCDN **TODO**
function Clear-CloudFilesObjectFromCDN{
}

#UpdateAccountMetadata

#UpdateContainerCdnHeaders **TODO**
function Update-CloudFilesContainerCDNHeaders{
}

#UpdateContainerMetadata **TODO**
function Update-CloudFilesContainerMetadata{
}

#UpdateObjectMetadata **TODO**
function Update-CloudFilesObjectMetadata{
}

#GetServiceEndpointCloudFiles
#GetServiceEndpointCloudFilesCDN

#VerifyContainerIsCDNEnabled **TODO**
function Test-CloudFilesContainerCDNEnabled{
}