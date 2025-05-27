# Retrieve all Active Directory users with specific properties
Get-ADUser -Filter * -Properties AccountExpirationDate, Description, MemberOf | 
    Select-Object `
        Name, 
        SamAccountName,
        UserPrincipalName,
        AccountExpirationDate,
        Description,
        @{Name="MemberOf"; Expression={
            # Process the MemberOf property to extract and sort group names
            $_.MemberOf | 
            ForEach-Object { 
                # Split the distinguished name and extract the common name (CN)
                $_.split(",")[0].replace("CN=", "") 
            } | 
            Sort-Object  # Sort the group names
        }} | 
    Sort-Object SamAccountName |  # Sort the results by the SamAccountName property
    # Export the results to a CSV file with a semicolon delimiter
    Export-CSV -Path aduser.csv -Delimiter ';' -NoTypeInformation
