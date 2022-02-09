cls

$all = Get-ChildItem CYMC_LOG #找出CYMC_LOG目錄底下有哪些資料夾

$currentdir = (Get-Location).toString()  #找到目前路徑

cd $currentdir"\CYMC_LOG" 

$cmd = $currentdir+"\tools\7z.exe";

foreach($objItem in $all ){
	cd $objItem.name
	$currentdir_2 = (Get-Location).toString()
	
	#開新目錄
	$fileExist = Test-Path -Path "backuplog"
	if($fileExist -ne "True"){
		New-Item -ItemType directory -Path "backuplog"
	}
	
	$currentdir_2 = (Get-Location).toString()+"\"
	For($i=1; $i -lt 10; $i++){ #$i為前幾個月
		
		$reserveDate = [DateTime]::Today.AddDays(-[DateTime]::Today.Day+1).AddMonths(-$i).ToString("yyyyMM") #得到目前想壓縮月份
		
		Get-ChildItem *.log | Where { $_.Name -like "*"+$reserveDate+"*" } |
		foreach { 
			$params = "a -mx9 $_.7z $_*.log".Split(" "); 
			& $cmd $params; 
			Move-Item -Path $currentdir_2\*.log.7z -Destination $currentdir_2\backuplog\ -force
			Remove-Item -path $_.name 
		}
	}
	cd ..
}
cd ..
#$Input = Read-Host -Prompt "Press any key to continue"