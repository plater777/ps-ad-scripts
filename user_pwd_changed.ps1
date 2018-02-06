# requires -version 2
<#
.SYNOPSIS
	Script que releva usuarios genéricos, hace cuanto cambiaron la contraseña y la última vez que se loguearon
	
.DESCRIPTION
	Script que releva usuarios genéricos, hace cuanto cambiaron la contraseña y la última vez que se loguearon
	
.INPUTS
	1. Ruta absoluta donde guardar el archivo CSV.
	2. Nombre que se desea dar al archivo CSV.
	
.OUTPUTS
	Exporta la lista a un archivo Csv
	
.NOTES
	Version: 1.0
	Author: Santiago Platero
	Creation Date: 06/02/2018
	Purpose/Change: Script que releva usuarios genéricos, hace cuanto cambiaron la contraseña y la última vez que se loguearon
	
.EXAMPLE
	>powershell -command ".'<absolute path>\user_pwd_changed.ps1'"
#>

#---------------------------------------------------------[Inicializaciones]-------------------------------------------------------
# Inicializaciones de variables
$users = Get-ADUser -Filter 'passwordneverexpires -eq "true"'
$path = Read-Host -Prompt 'Ingresar la ruta absoluta y donde desea guardar el archivo CSV: '
$fileName = Read-Host -Prompt 'Ingresar el nombre del archivo CSV: '

#----------------------------------------------------------[Declaraciones]----------------------------------------------------------
# Información del script
$scriptVersion = "1.0"
$scriptName = $MyInvocation.MyCommand.Name

#-----------------------------------------------------------[Funciones]------------------------------------------------------------
# Función para control de errores

Function Write-Exception
{
	Write-Host "[$(Get-Date -format $($dateFormat))] ERROR: $($_.Exception.Message)"
	exit 1
}

#-----------------------------------------------------------[Ejecución]------------------------------------------------------------
try 
{
	foreach ($user in $users)
	{
		if ($user.Enabled -eq "true")
		{
			if ($user.distinguishedname -notlike "*ventas*" -and $user.DistinguishedName -notlike "*sj*" -and $user.DistinguishedName -notlike "*vm*" -and $user.DistinguishedName -notlike "*pistolas*" -and $user.DistinguishedName -notlike "*remoto*" -and $user.DistinguishedName -notlike "*usuarios a*")
			{
				get-aduser -Identity $user.distinguishedname -Properties * | select samaccountname,CN,lastlogondate,passwordlastset,department,description,info,title | Export-Csv -Append -Delimiter ";" -notype $path"\"$fileName
			}
		}
	}
	exit 0
}
catch 
{ 
	Write-Exception
}

		